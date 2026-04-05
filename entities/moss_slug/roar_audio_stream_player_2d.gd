class_name RoarAudioStreamPlayer2D
extends AudioStreamPlayer2D

var _can_roar: bool = true

@onready var _cooldown_timer: RandomizedTimer = $CooldownRandomizedTimer

func _ready() -> void:
	if autoplay:
		_can_roar = false
		
		
func play_safe() -> void:
	if not playing:
		play()


func play_with_cooldown() -> void:
	if _can_roar and not playing:
		_can_roar = false
		play()
		

func _on_finished() -> void:
	# Start timer for cooldown after roar completes
	_cooldown_timer.start()


func _on_cooldown_randomized_timer_timeout() -> void:
	_can_roar = true


func _on_roar_randomized_timer_timeout() -> void:
	play_with_cooldown()
