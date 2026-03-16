class_name MapLayer
extends Node2D

var _next_tile_position: Vector2 = Vector2(165, 10000000)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


# Appends the given tile to the layer.
func add_tile(tile: MapTile) -> void:
	pass
	

# Clears all tiles from the layer.
func clear() -> void:
	pass
	
	
# Returns the position of the end of the map.
# Position is relative to the parent node (like .position).
func get_end_position() -> Vector2:
	return position + _next_tile_position
	
	
# Returns the position of the end of the map.
# Position is relative to this node.
func get_relative_end_position() -> Vector2:
	return _next_tile_position
