
extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 800.0

func _physics_process(delta):
	# Always run right
	velocity.x = SPEED
	
	# Apply gravity
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	move_and_slide()
	
	# Check if fallen far enough to trigger scene change
	if position.y > 500:
		get_tree().change_scene_to_file("res://scenes/main/main_game.tscn")
