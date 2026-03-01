extends Area2D

@export var speed = 200
@onready var screensize = get_viewport_rect().size

var position_history = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_axis("player_left", "player_right")

	if input > 0:
		$Character.frame = 7
	elif input < 0:
		$Character.frame = 6
	else:
		$Character.frame = 5
	
	position += Vector2(input, 0) * speed * delta

	position_history.append(global_position)
	
	
