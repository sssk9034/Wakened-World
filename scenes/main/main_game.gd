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
const SLUG_VELOCITY: float = 90.00
const EXIT_TILE_TARGET: Vector2 = Vector2(41, 270)
const INTRO_CHARACTER_OFFSET: Vector2 = Vector2(-295, -70)

var _exit_tile: MapTileEnd = null
var _exiting: bool = false

func _enter_tree() -> void:
	if singleton != null:
		_singleton.queue_free()
	_singleton = self

func _exit_tree() -> void:
	if singleton == self:
		_singleton.queue_free()
		_singleton = null

func _ready() -> void:
	_map.change_velocity(PLAYER_VELOCITY)
	
	_moss_slug.caught_player.connect(_on_moss_slug_caught_player)
	_player.reached_computer_target.connect(_on_player_reached_computer_target)

func _physics_process(_delta: float) -> void:
	if not _exiting:
		_moss_slug.target = _player.global_position
		_moss_slug.velocity = Vector2(0, SLUG_VELOCITY - _map.get_velocity())

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

func _on_player_enter_intro_scene(_tile: MapTileStart) -> void:
	if _player.can_user_control:
		_player.character.offset = INTRO_CHARACTER_OFFSET
		_player.character.animation = "intro"
		_player.can_user_control = false
