extends CharacterBody2D

@export var speed: int = 50

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	velocity = Vector2(0, speed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(_delta: float) -> void:
	move_and_slide()
