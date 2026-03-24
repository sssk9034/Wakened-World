class_name ObstacleTile
extends Node2D

## Defines information about the obstacle for the obstacle builder.
@export var type: ObstacleType = ObstacleType.new()
@export var probability: float = 1.0

var _velocity_modifier: Map.VelocityModifier = StopVelocityModifier.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
	
# Called when an Area2D enters the obstacle bounds.
func _on_area_2d_area_entered(_area: Area2D) -> void:
	_apply_velocity_modifier()


# Called when an Area2D exits the obstacle bounds.
func _on_area_2d_area_exited(_area: Area2D) -> void:
	_remove_velocity_modifier()
	

# Called when a PhysicsBody2D enters the obstacle bounds.
func _on_area_2d_body_entered(_body: Node2D) -> void:
	_apply_velocity_modifier()


# Called when a PhysicsBody2D exits the obstacle bounds.
func _on_area_2d_body_exited(_body: Node2D) -> void:
	_remove_velocity_modifier()


func _apply_velocity_modifier() -> void:
	Map.singleton.add_current_velocity_modifier(_velocity_modifier)
	
	
func _remove_velocity_modifier() -> void:
	Map.singleton.remove_current_velocity_modifier(_velocity_modifier)


class StopVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 100
	
	func mod_velocity(_old_velocity: float, _original_velocity: float) -> float:
		return 0.0
