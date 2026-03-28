class_name MapAreaModifier
extends Area2D

var _velocity_modifier: Map.VelocityModifier = ObstacleTile.StopVelocityModifier.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area_entered.connect(_on_area_2d_area_entered)
	area_exited.connect(_on_area_2d_area_exited)
	body_entered.connect(_on_area_2d_body_entered)
	body_exited.connect(_on_area_2d_body_exited)


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
