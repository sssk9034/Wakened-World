class_name ObstacleTile
extends Node2D

## Defines information about the obstacle for the obstacle builder.
@export var type: ObstacleType
@export var probability: float = 1.0

@export_range(0, 5000, 1, "suffix:ms", "or_greater") var extra_time: int = 0

var _velocity_modifier: Map.VelocityModifier = StopVelocityModifier.new()

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
	_velocity_modifier.add_velocity_modifier()
	
	
func _remove_velocity_modifier() -> void:
	_velocity_modifier.set_timeout(extra_time)


class StopVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 100
		type = ModifierTypes.CURRENT
	
	func mod_velocity(_old_velocity: float, _original_velocity: float) -> float:
		return 0.0
