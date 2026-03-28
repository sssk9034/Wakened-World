class_name ProceduralRNG
extends Resource

@export var rng_seed: String:
	set(value):
		rng_seed = value
		
		if rng_seed:
			_rng.seed = rng_seed.hash()
			_initial_state = _rng.state
			print("[ProceduralRNG]: Using seed: %s" % [rng_seed])
		else:
			_rng.randomize()
			print("[ProceduralRNG]: No seed provided, using random seed.")

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()
var _initial_state: int

func reset() -> void:
	if rng_seed:
		_rng.state = _initial_state


func set_state(state: int) -> void:
	_rng.state = state
	
	
func get_state() -> int:
	return _rng.state


func rand_weighted(weights: PackedFloat32Array) -> int:
	return _rng.rand_weighted(weights)
	

func randf() -> float:
	return _rng.randf()


func randf_range(from: float, to: float) -> float:
	return _rng.randf_range(from, to)
	

func randfn(mean: float = 0.0, deviation: float = 1.0) -> float:
	return _rng.randfn(mean, deviation)
	
	
func randi() -> int:
	return _rng.randi()
	
	
func randi_range(from: int, to: int) -> int:
	return _rng.randi_range(from, to)
