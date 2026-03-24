@tool
class_name ManualObstacleLayout
extends ObstacleLayout

@export var positions: Array[ManualObstaclePosition]:
	set(value):
		var pos: Array[ObstaclePosition] = []
		pos.assign(value)
		_positions = pos
	get:
		var pos: Array[ManualObstaclePosition] = []
		pos.assign(_positions)
		return pos

var _positions_index: int = 0

var _draw_node: Node = null

func get_next_obstacle() -> ObstacleTile:
	var tile: ObstacleTile = positions[_positions_index].tile_scene.instantiate()
	
	tile.position = positions[_positions_index].position
	tile.rotation = positions[_positions_index].rotation
	
	_positions_index += 1
	return tile
	
	
func has_next_obstacle() -> bool:
	return _positions_index < positions.size()


# Draws all obstacle positions. Mostly used in editor for viewing layout.
func draw_layout(canvas: CanvasItem) -> void:
	if _draw_node != null:
		_draw_node.queue_free()
		
	_draw_node = Node.new()
	changed.connect(_draw_node.queue_free)
	canvas.add_child(_draw_node)
		
	for obstacle: ManualObstaclePosition in get_positions():
		if obstacle.tile_scene == null:
			continue
		var tile: ObstacleTile = obstacle.tile_scene.instantiate()
		
		tile.position = obstacle.position
		tile.rotation = obstacle.rotation
		
		_draw_node.add_child(tile)
		
