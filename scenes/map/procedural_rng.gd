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
	_on_use()
	return _rng.rand_weighted(weights)
	

func randf() -> float:
	_on_use()
	return _rng.randf()


func randf_range(from: float, to: float) -> float:
	_on_use()
	return _rng.randf_range(from, to)
	

func randfn(mean: float = 0.0, deviation: float = 1.0) -> float:
	_on_use()
	return _rng.randfn(mean, deviation)
	
	
func randi() -> int:
	_on_use()
	return _rng.randi()
	
	
func randi_range(from: int, to: int) -> int:
	_on_use()
	return _rng.randi_range(from, to)


func _on_use() -> void:
	pass
	#print("[ProceduralRNG]: Used RNG")
