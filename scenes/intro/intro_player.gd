#extends CharacterBody2D
#
#const SPEED = 150.0
#const GRAVITY = 800.0
#
#@onready var animated_sprite = $AnimatedSprite2D
#
#var running = false  # wait for slug signal
#
#func _ready():
	#animated_sprite.play("idle")  # or whatever your standing animation is
#
#func start_running():
	#running = true
	#animated_sprite.play("run")
	#
	#
#
#func _physics_process(delta):
	#if running:
		#velocity.x = SPEED
#
	#if not is_on_floor():
		#velocity.y += GRAVITY * delta
#
	#move_and_slide()
#
	#if position.y > 500:
		#get_tree().change_scene_to_file("res://scenes/main/main_game.tscn")
		
		
extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 800.0

@onready var animated_sprite = $AnimatedSprite2D

var running = false
var sliding = false

func _ready():
	animated_sprite.play("idle")

func start_running():
	running = true
	animated_sprite.play("run")

func _physics_process(delta):
	if running and not sliding:
		velocity.x = SPEED

	if sliding:
		# Force downward slide/fall speed
		velocity.x = 0
		velocity.y = 200

	else:
		# Normal gravity
		if not is_on_floor():
			velocity.y += GRAVITY * delta

	move_and_slide()

	if sliding and position.y > 500:
		get_tree().change_scene_to_file("res://scenes/main/main_game.tscn")

		
		
		
func _on_slide_trigger_body_entered(body):
	if body == self:
		start_slide()
		
func start_slide():
	if sliding:
		return

	sliding = true
	running = false
	velocity = Vector2.ZERO

	animated_sprite.play("run_to_slide")
	await animated_sprite.animation_finished
	
	animated_sprite.play("slide")
