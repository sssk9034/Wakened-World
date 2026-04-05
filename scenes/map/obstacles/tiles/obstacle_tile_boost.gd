extends ObstacleTile

func _init() -> void:
	_velocity_modifier = BoostVelocityModifier.new()


class BoostVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 50
		type = ModifierTypes.TARGET
	
	func mod_velocity(old_velocity: float, _original_velocity: float) -> float:
		return old_velocity * 1.5
