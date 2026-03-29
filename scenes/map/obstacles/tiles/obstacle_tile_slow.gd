extends ObstacleTile

func _init() -> void:
	_velocity_modifier = MudVelocityModifier.new()


class MudVelocityModifier extends Map.VelocityModifier:
	func _init() -> void:
		priority = 50
		type = ModifierTypes.TARGET
	
	func mod_velocity(old_velocity: float, _original_velocity: float) -> float:
		return old_velocity * 0.5
