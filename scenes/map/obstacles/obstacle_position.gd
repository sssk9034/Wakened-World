@tool
class_name ObstaclePosition 
extends Resource
## Represents a posistion an obstacle can be placed at.
## Includes the positioning information of the obstacle.

@export var position: Vector2:
	set(value):
		position = value
		emit_changed()
@export_range(-90, 90, 0.1, "radians_as_degrees") var rotation: float:
	set(value):
		rotation = value
		emit_changed()


## Returns a Transform2D object representing the position and rotation.
func get_transform2d() -> Transform2D:
	return Transform2D(-rotation, position)
