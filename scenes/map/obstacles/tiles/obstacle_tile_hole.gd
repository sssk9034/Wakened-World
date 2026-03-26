extends ObstacleTile


func _apply_velocity_modifier() -> void:
	super()
	Player.singleton.trigger_hole_death(global_position)

func _remove_velocity_modifier() -> void:
	return
	
