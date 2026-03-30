class_name MainGame
extends Node2D

static var singleton: MainGame:
	get:
		return _singleton
static var _singleton: MainGame = null

@onready var _player: Player = $Player
@onready var _moss_slug: MossSlug = $MossSlug
@onready var _map: Map = $Map

var _death_scene: PackedScene = preload("res://ui/death/death_scene.tscn")
var _hole_death_scene: PackedScene = preload("res://ui/death/hole_death_scene.tscn")

const PLAYER_VELOCITY: float = 100.00
const SLUG_VELOCITY: float = 95.00
const EXIT_TILE_TARGET: Vector2 = Vector2(41, 270)
const INTRO_CHARACTER_OFFSET: Vector2 = Vector2(-295, -70)

const GAMEPLAY_CAMERA_ZOOM: Vector2 = Vector2(0.5, 0.5)
const INTRO_CINEMATIC_ZOOM: Vector2 = Vector2(0.92, 0.92)
const INTRO_CAMERA_PAN_Y: float = -102.0
const INTRO_CAMERA_PAN_START_X_EXTRA: float = -365.0
const INTRO_CAMERA_DROP_ZOOM_DURATION: float = 0.42
const SLUG_INTRO_AT_HORIZONTAL_PROGRESS: float = 0.70

var _exit_tile: MapTileEnd = null
var _exiting: bool = false
var _intro_camera_active: bool = false
var _intro_zoom_out_tween: Tween = null
var _slug_intro_launched: bool = false

func _enter_tree() -> void:
	if singleton != null:
		_singleton.queue_free()
	_singleton = self

func _exit_tree() -> void:
	_intro_camera_active = false
	if _intro_zoom_out_tween != null and _intro_zoom_out_tween.is_valid():
		_intro_zoom_out_tween.kill()
	_intro_zoom_out_tween = null
	if singleton == self:
		_singleton.queue_free()
		_singleton = null

func _ready() -> void:
	_map.change_velocity(PLAYER_VELOCITY)
	
	_moss_slug.caught_player.connect(_on_moss_slug_caught_player)
	_player.reached_computer_target.connect(_on_player_reached_computer_target)
	_player.intro_finished.connect(_finish_intro_camera_follow)

func _physics_process(_delta: float) -> void:
	var slug_chase: bool = not _exiting and not _intro_camera_active \
			and _player.can_user_control and not _player.dead
	_moss_slug.chase_horizontally_enabled = slug_chase
	if slug_chase:
		_moss_slug.target = _player.global_position
		
		if _player.global_position.y < _moss_slug.global_position.y:
			# Slug is ahead of player, stop slug
			_moss_slug.velocity.y = 0
		else:
			_moss_slug.velocity.y = SLUG_VELOCITY - _map.get_velocity()
	else:
		_moss_slug.velocity = Vector2.ZERO

	if _exit_tile != null:
		_player.computer_target = to_local(_exit_tile.to_global(EXIT_TILE_TARGET))

func _on_moss_slug_caught_player() -> void:
	kill_player("slug")

func scene_switcher(scene: PackedScene) -> void:
	get_tree().root.add_child(scene.instantiate())
	get_tree().create_timer(1.5).timeout.connect(queue_free)


func kill_player(cause: String) -> void:
	if _player.dead:
		return
	_player.dead = true
	
	if cause == "hole":
		on_hole_death()
	elif cause == "slug":
		on_slug_death()

func on_hole_death() -> void:
	scene_switcher(_hole_death_scene)

func on_slug_death() -> void:
	scene_switcher(_death_scene)

func _start_exit_camera_pan() -> void:
	var camera: Camera2D = _player.get_node("Camera2D")
	camera.position.y = -20.0
	var target_x: float = _player.character.offset.x * _player.character.scale.x + 45.0
	var tween: Tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(camera, "position:x", target_x, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "position:y", 30.0, 1.2) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(camera, "zoom", Vector2(1, 1), 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_player.character, "scale", Vector2(0.55, 0.55), 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	tween.tween_property(_player.character, "offset:y", 80.0, 2.0) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)

func _on_player_reached_computer_target() -> void:
	if _exit_tile == null:
		return
	_player.character.offset = Vector2(424, 40)
	_player.character.play(&"exit")
	_start_exit_camera_pan()
	_exit_tile = null


func _on_player_enter_exit_scene(tile: MapTileEnd) -> void:
	if _player.can_user_control:
		_player.character.animation = "straight"
		_player.can_user_control = false
	_player.speed = int(PLAYER_VELOCITY)
	_map.set_velocity(0)
	_moss_slug.velocity = Vector2.ZERO
	_exiting = true
	_exit_tile = tile
	_player.start_auto_walk()

func _finish_intro_camera_follow() -> void:
	if not _intro_camera_active:
		return
	_intro_camera_active = false
	_map.change_velocity(PLAYER_VELOCITY)
	var cam: Camera2D = _player.get_node("Camera2D") as Camera2D
	cam.offset = Vector2.ZERO
	cam.position = Vector2(0.0, INTRO_CAMERA_PAN_Y)
	cam.position_smoothing_enabled = false
	cam.drag_horizontal_enabled = false
	if not _slug_intro_launched:
		_moss_slug.play_intro_once_then_straight()
	if _intro_zoom_out_tween != null and _intro_zoom_out_tween.is_valid():
		_intro_zoom_out_tween.kill()
	cam.zoom = INTRO_CINEMATIC_ZOOM
	_intro_zoom_out_tween = create_tween()
	_intro_zoom_out_tween.set_parallel(true)
	_intro_zoom_out_tween.tween_property(cam, "position:y", 0.0, INTRO_CAMERA_DROP_ZOOM_DURATION) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_intro_zoom_out_tween.tween_property(cam, "zoom", GAMEPLAY_CAMERA_ZOOM, INTRO_CAMERA_DROP_ZOOM_DURATION) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)
	_intro_zoom_out_tween.chain()
	_intro_zoom_out_tween.tween_callback(_on_intro_camera_drop_finished)


func _on_intro_camera_drop_finished() -> void:
	var cam: Camera2D = _player.get_node("Camera2D") as Camera2D
	cam.position = Vector2.ZERO
	cam.zoom = GAMEPLAY_CAMERA_ZOOM
	cam.position_smoothing_enabled = true
	cam.drag_horizontal_enabled = true


func _apply_intro_camera_pan_x(pan_x: float) -> void:
	var cam: Camera2D = _player.get_node("Camera2D") as Camera2D
	cam.position = Vector2(pan_x, INTRO_CAMERA_PAN_Y)


func _update_intro_camera_from_intro_progress() -> void:
	var ch: AnimatedSprite2D = _player.character
	var sf: SpriteFrames = ch.sprite_frames
	var anim: StringName = &"intro"
	if sf == null or not sf.has_animation(anim):
		return
	var n: int = sf.get_frame_count(anim)
	if n <= 0:
		return
	var t: float = clampf((float(ch.frame) + ch.frame_progress) / float(n), 0.0, 1.0)
	var start_x: float = INTRO_CHARACTER_OFFSET.x * ch.scale.x + INTRO_CAMERA_PAN_START_X_EXTRA
	var pan_x: float = lerpf(start_x, 0.0, t)
	_apply_intro_camera_pan_x(pan_x)
	if not _slug_intro_launched and t >= SLUG_INTRO_AT_HORIZONTAL_PROGRESS:
		_slug_intro_launched = true
		_moss_slug.play_intro_once_then_straight()


func _start_intro_camera_sequence() -> void:
	var cam: Camera2D = _player.get_node("Camera2D") as Camera2D
	cam.position_smoothing_enabled = false
	cam.drag_horizontal_enabled = false
	cam.drag_vertical_enabled = false
	cam.zoom = INTRO_CINEMATIC_ZOOM
	cam.offset = Vector2.ZERO
	_slug_intro_launched = false
	_intro_camera_active = true
	_update_intro_camera_from_intro_progress()


func _process(_delta: float) -> void:
	if not _intro_camera_active:
		return
	if _player.character.animation != &"intro":
		return
	_update_intro_camera_from_intro_progress()


func _on_player_enter_intro_scene(_tile: MapTileStart) -> void:
	if _player.can_user_control:
		_player.character.offset = INTRO_CHARACTER_OFFSET
		_player.character.play(&"intro")
		_player.can_user_control = false
		_player.lock_intro_world_position()
		_map.set_velocity(0)
		_moss_slug.velocity = Vector2.ZERO
		_start_intro_camera_sequence()
