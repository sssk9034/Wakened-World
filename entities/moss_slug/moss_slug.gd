class_name MossSlug

extends CharacterBody2D

@export var _slug_follow_speed: float = 150.0

@onready var _slug_character: AnimatedSprite2D = $Character
@onready var _slug_drag_path: AnimatedSprite2D = $DragPath

var _active_shape: CollisionPolygon2D = null

@onready var _col_left: CollisionPolygon2D = $Slug2D/Col_left
@onready var _col_right: CollisionPolygon2D = $Slug2D/Col_right
@onready var _col_straight: CollisionPolygon2D = $Slug2D/Col_straight

@export var target: Vector2

signal caught_player

const SLUG_INTRO_VISUAL_OFFSET_Y: float = 48.0

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
	move_and_slide()


func _update_moss_slug(delta: float) -> void:
	var distance_x: float = target.x - global_position.x
	var can_chase: bool = Player.singleton != null and Player.singleton.can_user_control \
			and not Player.singleton.dead

	if can_chase and absf(distance_x) > 1.0:
		global_position.x += sign(distance_x) * _slug_follow_speed * delta
		if distance_x > 0.0:
			_slug_character.animation = &"right"
			_slug_drag_path.animation = &"right"
		else:
			_slug_character.animation = &"left"
			_slug_drag_path.animation = &"left"
	else:
		_slug_character.animation = &"straight"
		_slug_drag_path.animation = &"straight"

	_update_collision_shape(String(_slug_character.animation))


func _on_slug_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	caught_player.emit()
