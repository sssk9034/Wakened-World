extends Node2D

## Constant speed at which the slug approaches the player on screen (px/s).
## Independent of map velocity — the slug always visually crawls at this rate.
@export var slug_approach_speed: float = 5.0
## How fast the slug follows the player horizontally (px/s).
@export var slug_follow_speed: float = 150.0

@onready var _player: Player = $Player
@onready var _moss_slug: Area2D = $MossSlug
@onready var _slug_character: AnimatedSprite2D = $MossSlug/Character
@onready var _slug_drag_path: AnimatedSprite2D = $MossSlug/DragPath

var _slug_start_y: float = 0.0
var _elapsed_time: float = 0.0


func _ready() -> void:
	SignalBus.obstacle_collided.connect(_on_obstacle_collided)
	SignalBus.obstacle_cleared.connect(_on_obstacle_cleared)
	_moss_slug.body_entered.connect(_on_moss_slug_caught_player)
	_slug_start_y = _moss_slug.position.y


func _physics_process(delta: float) -> void:
	_update_moss_slug(delta)


func _update_moss_slug(delta: float) -> void:
	_elapsed_time += delta

	# Vertical: position calculated from start, guaranteeing constant speed
	_moss_slug.position.y = _slug_start_y + slug_approach_speed * _elapsed_time

	# Horizontal: follow the player directly
	var target_x: float = _player.global_position.x
	var distance_x: float = target_x - _moss_slug.global_position.x

	if abs(distance_x) > 1.0:
		_moss_slug.global_position.x += sign(distance_x) * slug_follow_speed * delta

		if distance_x > 0:
			_slug_character.animation = "right"
			_slug_drag_path.animation = "right"
		else:
			_slug_character.animation = "left"
			_slug_drag_path.animation = "left"
	else:
		_slug_character.animation = "straight"
		_slug_drag_path.animation = "straight"


func _on_moss_slug_caught_player(_body: Node2D) -> void:
	get_tree().change_scene_to_file("res://ui/death/death_scene.tscn")


func _on_obstacle_collided(obstacle: ObstacleTile) -> void:
	if obstacle.is_in_group("Holes"):
		print("[MainGame]: Player fell in a hole! Game Over!")


func _on_obstacle_cleared(_obstacle: ObstacleTile) -> void:
	pass
