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

var _draw_node: CanvasItem = null

func get_next_obstacle() -> ObstacleTile:
	var tile: ObstacleTile = positions[_positions_index].tile_scene.instantiate()
	
	tile.position = positions[_positions_index].position
	
	if tile.rotatable:
		tile.rotation = positions[_positions_index].rotation
	
	_positions_index += 1
	return tile
	
	
func has_next_obstacle() -> bool:
	return _positions_index < positions.size()


# Draws all obstacle positions. Mostly used in editor for viewing layout.
func draw_layout(canvas: CanvasItem) -> void:
	if _draw_node != null:
		_draw_node.queue_free()
		
	_draw_node = Node2D.new()
	changed.connect(_draw_node.queue_free)
	canvas.add_child(_draw_node)
		
	for obstacle: ManualObstaclePosition in get_positions():
		draw_obstacle(_draw_node as CanvasItem, obstacle)
		

## Draws an obstacles position. Mostly used in editor for viewing layout.
func draw_obstacle(canvas: CanvasItem, obstacle: ObstaclePosition) -> void:
	var manual_obstacle: ManualObstaclePosition = obstacle as ManualObstaclePosition
	
	if manual_obstacle.tile_scene == null:
		return
	var tile: ObstacleTile = manual_obstacle.tile_scene.instantiate()
	
	tile.position = obstacle.position
	tile.rotation = obstacle.rotation
	
	canvas.add_child(tile)
