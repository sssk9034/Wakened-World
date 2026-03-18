@tool
class_name PositionListObstacleLayout
extends ObstacleLayout

@export var positions: Array[Vector2]:
	set(value):
		positions = value
		emit_changed()

func get_positions() -> Array[Vector2]:
	return positions
