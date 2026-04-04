extends PointLight2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var target_pos: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	var angle_to: float = global_position.angle_to_point(target_pos)
	rotation = angle_to
	
