class_name RandomizedTimer
extends Timer

## Minimum randomized wait time.
@export_range(0.001, 4096.0, 0.001, "suffix:s", "or_greater", "exp") \
		var min_wait_time: float = 1.0
## Maximum randomized wait time.
@export_range(0.001, 4096.0, 0.001, "suffix:s", "or_greater", "exp") \
		var max_wait_time: float = 1.0

@export var rng_seed: String:
	set(value):
		rng_seed = value
		if rng_seed:
			_rng.seed = rng_seed.hash()
		else:
			_rng.randomize()

var _rng: RandomNumberGenerator = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	timeout.connect(_on_timeout)
	_randomize_wait_time()


func _randomize_wait_time() -> void:
	wait_time = _rng.randf_range(min_wait_time, max_wait_time)


func _on_timeout() -> void:
	# Assigns the next random wait time value
	_randomize_wait_time()
