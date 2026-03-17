class_name MapTile
extends Node2D

@export var probability: float = 1.0

@onready var _next_tile_marker: Marker2D = $NextTileMarker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

## Returns the relative offset that the next tile should be placed at to
## connect to this tile.
func get_next_tile_offset() -> Vector2:
	return _next_tile_marker.position
