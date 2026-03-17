class_name TestMapBuilder
extends MapBuilder

var tile_scenes_index: int = 0
@export var tile_scenes: Array[PackedScene] = []
@export var map_length: int = 0

var _tile_count: int = 0

func _ready() -> void:
	if map_length <= 0:
		map_length = tile_scenes.size() * 2
	

func get_next_tile() -> MapTile:
	var tile: MapTile = tile_scenes[tile_scenes_index].instantiate()
	
	tile_scenes_index += 1
	if tile_scenes_index >= tile_scenes.size():
		tile_scenes_index = 0
	
	_tile_count += 1
	return tile


func has_next_tile() -> bool:
	return _tile_count < map_length
