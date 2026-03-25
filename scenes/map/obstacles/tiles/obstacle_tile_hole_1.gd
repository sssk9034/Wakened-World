extends ObstacleTile

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _apply_velocity_modifier() -> void:
	super()
	Player.singleton.trigger_hole_death(global_position)

func _remove_velocity_modifier() -> void:
	return
	
