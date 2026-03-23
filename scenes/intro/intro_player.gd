
extends CharacterBody2D

const SPEED = 140.0  # slightly slower than player
const GRAVITY = 800.0

@onready var player = get_parent().get_node("intro_slug")

func _physics_process(delta):
	if player == null:
		return
	
	# Just chase the player horizontally
	if player.position.x > position.x:
		velocity.x = SPEED
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()
