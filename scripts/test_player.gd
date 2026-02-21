extends CharacterBody2D

@export var speed: float = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	var input: float = Input.get_axis("player_left","player_right")
	velocity = Vector2(input, 0) * speed
	move_and_slide()
	

	
