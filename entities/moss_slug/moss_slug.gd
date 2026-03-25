class_name MossSlug

@onready var character: AnimatedSprite2D = $Character
@onready var drag_path: AnimatedSprite2D = $DragPath
@onready var roar: AudioStreamPlayer2D = $Roar
extends CharacterBody2D

@export var _slug_follow_speed: float = 150.0

@onready var _slug_character: AnimatedSprite2D = $Character
@onready var _slug_drag_path: AnimatedSprite2D = $DragPath

var _active_shape: CollisionPolygon2D = null

var has_roared_this_move: bool = false
var roar_detector = 0

func _ready() -> void:
	pass

func _physics_process(delta: float) -> void:
	if player.position_history.size() > delay_frames:
		var target_x: float = player.position_history[0]
		player.position_history.remove_at(0)
		
		var distance: float = target_x - global_position.x

		
		start_roar(distance)

		if abs(distance) > 1.0:
			# Movement
			global_position += Vector2(distance, 0).normalized() * speed * delta

			# Animation
			if distance > 0:
				character.animation = "right"
				drag_path.animation = "right"
			elif distance < 0:
				character.animation = "left"
				drag_path.animation = "left"
		else:
			character.animation = "straight"
			drag_path.animation = "straight"


#makes sure to play the roar at the start of the game
func start_roar(distance: float) -> void:
	if abs(distance) > 1.0:
			var roar_state = true
			if (roar_state == false):
				play_roar()
				
#detects if the monster is close to the player.
#func close_roar() -> bool:
	## Track if the monster has moved and already roared
#
	#if (roar_detector == 1):
		#has_roared_this_move = true
	#
	#roar_detector = 1
	#return has_roared_this_move

func play_roar() -> void:
	roar.stop()
	roar.play()
@onready var _col_left: CollisionPolygon2D = $Slug2D/Col_left
@onready var _col_right: CollisionPolygon2D = $Slug2D/Col_right
@onready var _col_straight: CollisionPolygon2D = $Slug2D/Col_straight

@export var target: Vector2

signal caught_player

func _ready() -> void:
	_col_left.disabled = true
	_col_right.disabled = true
	_col_straight.disabled = false
	_active_shape = _col_straight


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
	_update_moss_slug(delta)
	move_and_slide()
	
func _update_moss_slug(delta: float) -> void:
	
	var distance_x: float = target.x - global_position.x

	if abs(distance_x) > 1.0:
		global_position.x += sign(distance_x) * _slug_follow_speed * delta

		if distance_x > 0:
			_slug_character.animation = "right"
			_slug_drag_path.animation = "right"
		else:
			_slug_character.animation = "left"
			_slug_drag_path.animation = "left"
	else:
		_slug_character.animation = "straight"
		_slug_drag_path.animation = "straight"
		
	_update_collision_shape(_slug_character.animation)


func _on_slug_2d_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	caught_player.emit()
