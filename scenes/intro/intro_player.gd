extends CharacterBody2D

const SPEED = 150.0
const GRAVITY = 800.0

@onready var animated_sprite = $AnimatedSprite2D

var running = false  # wait for slug signal

func _ready():
	animated_sprite.play("idle")  # or whatever your standing animation is

func start_running():
	running = true
	animated_sprite.play("run")

func _physics_process(delta):
	if running:
		velocity.x = SPEED

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()

	if position.y > 500:
		get_tree().change_scene_to_file("res://scenes/main/main_game.tscn")
