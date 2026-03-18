class_name ProceduralMapBuilder
extends MapBuilder

@export var map_seed: String = ""
## Set to 0 to generate based on map_seed
@export_range(0, 100, 1, "or_greater") var map_length: int = 0

var _rng_seed: int = 0
var _rng_use_seed: bool = false

func _init() -> void:
	_update_map_seed()
	_update_map_length()

func get_next_tile() -> MapTile:
	return null


func has_next_tile() -> bool:
	return false


## Updates the rng seed if map_seed is not empty, otherwise uses a random seed.
func _update_map_seed() -> void:
	if map_seed:
		_rng_seed = map_seed.hash()
		_rng_use_seed = true
		print("[Map]: Using seed: %s (%d)" % [map_seed, _rng_seed])
	else:
		print("[Map]: No seed provided, using random seed.")
		_rng_use_seed = false
		

## Updates the map length.
## If map_length is <= 0 then the length is determine by summing the ord()
## of all the characters in map_seed.
## If map_length is >= 1 then it is used as the map_length
func _update_map_length() -> void:
	if map_length <= 0:
		# Generate based on map_seed
		var sum: int = 0
		
		for c: String in map_seed:
			sum += ord(c)
		
		map_length = sum
		print("[Map]: Generated map length: %s" % [map_length])
	else:
		# Use specified map length
		print("[Map]: Using provided map length: %s" % [map_length])
	
