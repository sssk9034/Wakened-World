@tool
@abstract
class_name ObstacleLayout
extends Resource
## Abstract class for obstacle layouts.

const POS_INDICATOR_LINES: PackedVector2Array = [
	Vector2(-10, 0), Vector2(10, 0), # X-axis line
	Vector2(0, -10), Vector2(0, 10), # Y-axis line
	Vector2(0, 10), Vector2(-5, 5), # Left arrow segment
	Vector2(0, 10), Vector2(5, 5), # Right arrow segment
]
const POS_INDICATOR_COLORS: PackedColorArray = [
	Color(1.0, 0.0, 0.0), # X-axis line
	Color(0.0, 1.0, 0.0), # Y-axis line
	Color(0.0, 1.0, 0.0), # Left arrow segment
	Color(0.0, 1.0, 0.0), # Right arrow segment
]

## Positions of obstacles to place.
var _positions: Array[ObstaclePosition]:
	set(value):
		if Engine.is_editor_hint():
			for pos: ObstaclePosition in _positions:
				if pos != null:
					pos.changed.disconnect(emit_changed)
			for pos: ObstaclePosition in value:
				if pos != null:
					pos.changed.connect(emit_changed)
		
		_positions = value
		emit_changed()


func _init() -> void:
	# Required since resources are normally not duplicated
	resource_local_to_scene = true


## Returns a array of ObstaclePositions.
func get_positions() -> Array[ObstaclePosition]:
	# Filter out null elements
	var arr: Array[ObstaclePosition] = _positions.filter(
		func(pos: ObstaclePosition) -> bool: return pos != null
	)
	return arr


## Returns the next obstacle to place.
## Position and rotation are already set on the tile.
@abstract func get_next_obstacle() -> ObstacleTile


## Returns true if there is another obstacle to place.
@abstract func has_next_obstacle() -> bool


## Draws all obstacle positions. Mostly used in editor for viewing layout.
func draw_layout(canvas: CanvasItem) -> void:
	for obstacle: ObstaclePosition in get_positions():
		canvas.draw_set_transform_matrix(obstacle.get_transform2d())
		canvas.draw_multiline_colors(POS_INDICATOR_LINES, POS_INDICATOR_COLORS)
		
