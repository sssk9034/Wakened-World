extends ObstacleTile

@onready var timer: Timer = $Timer

var _is_active: bool = false

func _init() -> void:
	_velocity_modifier = BoostVelocityModifier.new()

func _apply_velocity_modifier() -> void:
	if not _is_active:
		_is_active = true
		Map.singleton.add_target_velocity_modifier(_velocity_modifier)

func _remove_velocity_modifier() -> void:
	timer.start()
	

func _on_timer_timeout() -> void:
	Map.singleton.remove_target_velocity_modifier(_velocity_modifier)
	_is_active = false

class BoostVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 50
	
	func mod_velocity(old_velocity: float, _original_velocity: float) -> float:
		return old_velocity * 2
