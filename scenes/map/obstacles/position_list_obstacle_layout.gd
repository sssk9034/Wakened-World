@tool
class_name PositionListObstacleLayout
extends ObstacleLayout

@export var positions: Array[ObstaclePosition]:
	set(value):
		positions = value
		emit_changed()

func get_transforms() -> Array[Transform2D]:
	var transforms: Array[Transform2D] = []
	
	for pos: ObstaclePosition in positions:
		if pos != null:
			transforms.append(Transform2D(pos.rotation, pos.position))
	
	return transforms
	
class ObstaclePosition extends Resource:
	@export var position: Vector2:
		set(value):
			position = value
			emit_changed()
	@export_range(-90, 90, 0.1, "radians_as_degrees") var rotation: float:
		set(value):
			rotation = value
			emit_changed()
