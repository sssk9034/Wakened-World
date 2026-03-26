extends ObstacleTile

@onready var timer: Timer = $Timer

func _init() -> void:
	_velocity_modifier = BoostVelocityModifier.new()

func _apply_velocity_modifier() -> void:
	Map.singleton.add_target_velocity_modifier(_velocity_modifier)

func _remove_velocity_modifier() -> void:
	timer.start()
	

func _on_timer_timeout() -> void:
	Map.singleton.remove_target_velocity_modifier(_velocity_modifier)

class BoostVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 50
	
	func mod_velocity(old_velocity: float, _original_velocity: float) -> float:
		return old_velocity * 2
