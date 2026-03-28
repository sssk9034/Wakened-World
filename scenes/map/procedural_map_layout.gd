class_name ProceduralMapLayout
extends MapLayout

@export var map_rng: ProceduralRNG

## Set to 0 to generate based on map_rng
@export_range(0, 100, 1, "or_greater") var map_length: int = 0:
	set(value):
		if value <= 0:
			# Generate based on map_rng
			map_length = map_rng.randi_range(10, 30)
			map_rng.reset()
			print("[Map]: Generated map length: %s" % [map_length])
		else:
			# Use specified map length
			map_length = value
			print("[Map]: Using provided map length: %s" % [map_length])

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

	
