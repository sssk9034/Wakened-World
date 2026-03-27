class_name StartEndSceneMapLayout
extends MapLayout

@export var map_layout: MapLayout

@export var start_tile_scene: PackedScene
@export var end_tile_scene: PackedScene

var _is_first: bool = true
var _is_done: bool = false

func get_next_tile() -> MapTile:
	if _is_first:
		_is_first = false
		return start_tile_scene.instantiate()
	
	if map_layout.has_next_tile():
		return map_layout.get_next_tile()
	
	# map_layout is done placing tiles, so place end_tile
	_is_done = true
	return end_tile_scene.instantiate()


func has_next_tile() -> bool:
	return not _is_done
