class_name TestMapBuilder
extends MapBuilder

var tile_scenes_index: int = 0
@export var tile_scenes: Array[PackedScene] = []


func get_next_tile() -> MapTile:
	var tile: MapTile = tile_scenes[tile_scenes_index].instantiate()
	
	tile_scenes_index += 1
	if tile_scenes_index >= tile_scenes.size():
		tile_scenes_index = 0
	
	return tile
