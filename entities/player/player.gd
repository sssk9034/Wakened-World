extends Area2D

#Add player speed as a variable in inspector
@export var speed = 200

#
@onready var screensize = get_viewport_rect().size

#init position history list for moss slug script
var position_history = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_axis("player_left", "player_right")

#set sprite frame to left slide for left input, right frame for right input, straight frame for no input
	if input > 0:
		$Character.frame = 7
	elif input < 0:
		$Character.frame = 6
	else:
		$Character.frame = 5
	
	#manage horizontal movement with input, speed, delta
	position += Vector2(input, 0) * speed * delta

	#append players position to the position history list
	position_history.append(global_position.x)
	
	
