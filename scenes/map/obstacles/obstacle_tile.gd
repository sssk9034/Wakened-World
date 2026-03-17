class_name ObstacleTile
extends Node2D

const POSITION_LEFT: int = 1
const POSITION_CENTER: int = 2
const POSITION_RIGHT: int = 4

## Path positions that this obstacle is allowed to be placed in.
@export_flags("Left", "Center", "Right") var allowed_positions: int = 7
## Allows two obstacles (one of them will be slowdown/speedup patch) to be placed
## next to one another.
@export var allow_double_obstacle: bool = true
@export var probability: float = 1.0

var _velocity_modifier: Map.VelocityModifier = StopVelocityModifier.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
# Called when the player enters the obstacle bounds.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	Map.singleton.add_current_velocity_modifier(_velocity_modifier)


# Called when the player exits the obstacle bounds.
func _on_area_2d_body_exited(_body: Node2D) -> void:
	Map.singleton.remove_current_velocity_modifier(_velocity_modifier)


class StopVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 100
	
	func mod_velocity(_old_velocity: float, _original_velocity: float) -> float:
		return 0.0
