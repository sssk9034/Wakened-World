@tool
class_name ObstacleSpawner
extends Node2D
##

@export_group("Generation")
@export var obstacle_builder: ObstacleBuilder

@export_group("Positioning")
@export_range(-100, 100, 0.01, "suffix:px") var left_position: float = -60.0:
	set(value):
		left_position = value
		queue_redraw()
@export_range(-100, 100, 0.01, "suffix:px") var center_position: float = 0.0:
	set(value):
		center_position = value
		queue_redraw()
@export_range(-100, 100, 0.01, "suffix:px") var right_position: float = 60.0:
	set(value):
		right_position = value
		queue_redraw()

func _init() -> void:
	# Build obstacles
	var struct: ObstacleStructure = obstacle_builder.get_next_obstacle_set()
	
	_place_obstacle(left_position, struct.left)
	_place_obstacle(center_position, struct.center)
	_place_obstacle(right_position, struct.right)
	

func _draw() -> void:
	if Engine.is_editor_hint():
		draw_circle(Vector2(left_position, 0), 3.0, Color(1.0, 0.0, 0.0))
		draw_circle(Vector2(center_position, 0), 3.0, Color(0.0, 0.0, 1.0))
		draw_circle(Vector2(right_position, 0), 3.0, Color(0.0, 1.0, 0.0))
	
	
func _place_obstacle(offset: float, obstacle: ObstacleTile) -> void:
	obstacle.position.x = offset
	add_child(obstacle)
	
	
