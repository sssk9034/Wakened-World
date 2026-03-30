class_name MossSlug

extends CharacterBody2D

@export_range(1, 500, 0.01, "suffix:px/s²") var acceleration_x_axis: float = 70.0
@export_range(0, 200, 0.01, "suffix:px/s") var velocity_x_axis: float = 100.0

@onready var _slug_character: AnimatedSprite2D = $Character
@onready var _slug_drag_path: AnimatedSprite2D = $DragPath

var _active_shape: CollisionPolygon2D = null

@onready var _col_left: CollisionPolygon2D = $Slug2D/Col_left
@onready var _col_right: CollisionPolygon2D = $Slug2D/Col_right
@onready var _col_straight: CollisionPolygon2D = $Slug2D/Col_straight

@export var target: Vector2

var _target_velocity: float = 0.0
var _current_velocity: float = 0.0

#player distance based roar sound effect
@export var roar_distance: float = 90.0   # distance threshold
@export var roar_cooldown: float = 5.0     # seconds

var _can_roar: bool = true
@onready var _roar_player: AudioStreamPlayer2D = $Roar


## Set by gameplay (e.g. MainGame): horizontal chase uses global_position, not velocity.
var chase_horizontally_enabled: bool = false

signal caught_player

const SLUG_INTRO_VISUAL_OFFSET_Y: float = 48.0
const SLUG_ANIMATION_TRIGGER_VELOCITY: float = 20.0
const SLUG_WANDER_VELOCITY: float = 10.0

var _intro_reaction_active: bool = false
var _slug_character_rest_y: float = 0.0
var _slug_drag_path_rest_y: float = 0.0


func _ready() -> void:
	_col_left.disabled = true
	_col_right.disabled = true
	_col_straight.disabled = false
	_active_shape = _col_straight
	_slug_character_rest_y = _slug_character.position.y
	_slug_drag_path_rest_y = _slug_drag_path.position.y
	_slug_drag_path.play(&"straight")
	_slug_character.play(&"straight")
	_update_collision_shape("straight")


func play_intro_once_then_straight() -> void:
	if _intro_reaction_active:
		return
	_intro_reaction_active = true
	_apply_slug_intro_visual_offset()
	_slug_character.animation_finished.connect(_on_intro_reaction_finished, CONNECT_ONE_SHOT)
	_slug_character.play(&"intro")


func _apply_slug_intro_visual_offset() -> void:
	_slug_character.position.y = _slug_character_rest_y + SLUG_INTRO_VISUAL_OFFSET_Y
	_slug_drag_path.position.y = _slug_drag_path_rest_y + SLUG_INTRO_VISUAL_OFFSET_Y


func _clear_slug_intro_visual_offset() -> void:
	_slug_character.position.y = _slug_character_rest_y
	_slug_drag_path.position.y = _slug_drag_path_rest_y


func _on_intro_reaction_finished() -> void:
	_intro_reaction_active = false
	_clear_slug_intro_visual_offset()
	_slug_character.play(&"straight")


func _update_collision_shape(pos: String) -> void:
	if _active_shape != null:
		_active_shape.disabled = true

	if pos == "left":
		_active_shape = _col_left
	elif pos == "right":
		_active_shape = _col_right
	elif pos == "straight":
		_active_shape = _col_straight

	if _active_shape != null:
		_active_shape.disabled = false


func _physics_process(delta: float) -> void:
	if _intro_reaction_active:
		_apply_slug_intro_visual_offset()
		_slug_drag_path.animation = &"straight"
		_update_collision_shape("straight")
		move_and_slide()
		return
		
	_update_moss_slug(delta)
	_check_roar_condition()
	move_and_slide()


func _update_moss_slug(delta: float) -> void:
	if chase_horizontally_enabled:
		var distance_x: float = target.x - global_position.x
		
		_target_velocity = clamp(distance_x * 2, -velocity_x_axis, velocity_x_axis)
		
		_calc_acceleration(delta)
		velocity.x = _current_velocity
		
	else:
		_target_velocity = 0.0
		_current_velocity = 0.0
		velocity.x = 0.0
		
	if velocity.x > SLUG_ANIMATION_TRIGGER_VELOCITY:
		_slug_character.animation = &"right"
		_slug_drag_path.animation = &"right"
	elif velocity.x < -SLUG_ANIMATION_TRIGGER_VELOCITY:
		_slug_character.animation = &"left"
		_slug_drag_path.animation = &"left"
	else:
		_slug_character.animation = &"straight"
		_slug_drag_path.animation = &"straight"

	_update_collision_shape(String(_slug_character.animation))


## Updates _target_velocity if _current_velocity != _target_velocity, using acceleration values.
func _calc_acceleration(delta: float) -> void:
	if _target_velocity > _current_velocity:
		# Increasing velocity
		_current_velocity = min(
				_current_velocity + (acceleration_x_axis * delta),
				_target_velocity)
				
	elif _target_velocity < _current_velocity:
		# Decreasing velocity
		_current_velocity = max(
				_current_velocity - (acceleration_x_axis * delta),
				_target_velocity)


func _on_slug_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	caught_player.emit()

func _check_roar_condition() -> void:
	if not _can_roar:
		return
	
	var distance: float = global_position.distance_to(target)
	
	if distance <= roar_distance:
		_play_roar_with_cooldown()
		

func _play_roar_with_cooldown() -> void:
	if _roar_player != null:
		_roar_player.play()

	_can_roar = false
	await get_tree().create_timer(roar_cooldown).timeout
	_can_roar = true
