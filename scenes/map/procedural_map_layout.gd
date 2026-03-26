class_name ProceduralMapLayout
extends MapLayout

## Set to 0 to generate based on map_seed
@export_range(0, 100, 1, "or_greater") var map_length: int = 0

@export var map_rng: ProceduralRNG:
	set(value):
		map_rng = value
		_update_map_length()

@export var map_tile_list: Array[PackedScene]:
	set(value):
		map_tile_list = value
		_map_tile_weights.clear()
		for scene: PackedScene in value:
			var map_tile: MapTile = scene.instantiate()
			_map_tile_weights.append(map_tile.probability)

var _map_tile_weights: PackedFloat32Array
var _count: int = 0

func get_next_tile() -> MapTile:
	var tile_index: int = map_rng.rand_weighted(_map_tile_weights)
	
	_count += 1
	return map_tile_list[tile_index].instantiate()


func has_next_tile() -> bool:
	return _count < map_length

## Updates the map length.
## If map_length is <= 0 then the length is determine by the rng
## If map_length is >= 1 then it is used as the map_length
func _update_map_length() -> void:
	if map_length <= 0:
		# Generate based on map_seed
		map_length = map_rng.randi_range(10, 30)
		print("[Map]: Generated map length: %s" % [map_length])
	else:
		# Use specified map length
		print("[Map]: Using provided map length: %s" % [map_length])
	
