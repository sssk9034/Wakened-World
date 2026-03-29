extends AudioStreamPlayer2D

@export var min_delay: float = 30
@export var max_delay: float = 40

var timer: float = 0.0

func _ready() -> void:
	play_roar()
	randomize()
	_reset_timer()

func _process(delta: float) -> void:
	timer -= delta
	
	if timer <= 0.0:
		_play_random_sound()
		_reset_timer()

func _play_random_sound() -> void:
	stop() # restart cleanly if already playing
	play()
	
func play_roar() -> void:
	stop()
	play()

func _reset_timer() -> void:
	timer = randf_range(min_delay, max_delay)
	
	
#Distance closing roar
#func start_roar(distance: float) -> void:
#	if abs(distance) > 1.0:
#		var roar_state = true
#		if roar_state == false:
#			play_roar()

#start_roar(distance_x)
