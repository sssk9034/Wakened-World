class_name MapLayer
extends Node2D

var tile_count: int:
	get:
		return _tile_count
var _tile_count: int = 0
var _next_tile_position: Vector2 = Vector2(0, 0)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


## Appends the given tile to the layer.
func add_tile(tile: MapTile) -> void:
	tile.position = _next_tile_position
	add_child(tile)
	_next_tile_position += tile.get_next_tile_offset()
	_tile_count += 1
	

## Clears all tiles from the layer.
func clear() -> void:
	for n: Node in get_children():
		#remove_child(n)
		n.queue_free()
		
	_next_tile_position = Vector2(0, 0)
	_tile_count = 0
	
	
## Returns the position of the end of the map.
## Position is relative to the parent node (like .position).
func get_end_position() -> Vector2:
	return position + _next_tile_position
	
	
## Returns the position of the end of the map.
## Position is relative to this node.
func get_relative_end_position() -> Vector2:
	return _next_tile_position
	

func is_empty() -> bool:
	return _tile_count <= 0
