@tool
class_name ProceduralObstacleLayout
extends ObstacleLayout

@export var positions: Array[ProceduralObstaclePosition]:
	set(value):
		var pos: Array[ObstaclePosition] = []
		pos.assign(value)
		_positions = pos
	get:
		var pos: Array[ProceduralObstaclePosition] = []
		pos.assign(_positions)
		return pos

var _positions_index: int = 0
var _position_ids_list: Dictionary[int, Array] = {} # Array[ObstacleType]

func get_next_obstacle() -> ObstacleTile:
	var pos: ProceduralObstaclePosition = positions[_positions_index]
	var filter: ObstacleFilter = pos.allowed_types
	
	# AND all placed obstacles allowed_next_to filters in the same position_id
	for t: ObstacleType in _position_ids_list.get(pos.position_id, []):
		filter = filter.filter_and(t.allowed_next_to)
	
	var tile: ObstacleTile = null
	
	tile.position = pos.position
	tile.rotation = pos.rotation
	
	_positions_index += 1
	return tile
	
	
func has_next_obstacle() -> bool:
	return _positions_index < positions.size()


## Draws an obstacles position. Mostly used in editor for viewing layout.
func draw_obstacle(canvas: CanvasItem, obstacle: ObstaclePosition) -> void:
	super(canvas, obstacle)
	
	var procedural_obstacle: ProceduralObstaclePosition = obstacle as ProceduralObstaclePosition
	
	if procedural_obstacle.position_id >= 0:
		canvas.draw_string(
			ThemeDB.fallback_font,
			Vector2(3, -8),
			"%d" % [procedural_obstacle.position_id],
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			10,
			Color(1.0, 0.0, 0.0, 1.0))
