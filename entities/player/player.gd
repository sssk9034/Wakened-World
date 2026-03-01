extends Area2D

@export var speed = 200
@onready var screensize = get_viewport_rect().size

var position_history = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var input = Input.get_vector("left","right","up","down")

	if input.x > 0:
		$Character.frame = 7
	elif input.x < 0:
		$Character.frame = 6
	else:
		$Character.frame = 5
	
	position += input * speed * delta
	position = position.clamp(Vector2(20,45), screensize - Vector2(20,45))
	
	position_history.append(global_position)
	
	if position_history.size()>300:
		position_history.pop_front()
