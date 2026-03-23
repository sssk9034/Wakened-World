extends CharacterBody2D

const SPEED = 140.0
const GRAVITY = 800.0
const FADE_DURATION = 2.0   # seconds to fade in
const ROAR_DURATION = 2.0   # seconds to play roar before chasing

@onready var player = get_parent().get_node("intro_player")
@onready var animated_sprite = $AnimatedSprite2D

var state = "roar"  # states: "roar", "chase"
var roar_timer = 0.0
var fade_timer = 0.0
var chasing = false

func _ready():
	modulate.a = 0.0
	# don't play anything yet

func _physics_process(delta):
	if player == null:
		return

	# Fade in
	if fade_timer < FADE_DURATION:
		fade_timer += delta
		modulate.a = clamp(fade_timer / FADE_DURATION, 0.0, 1.0)
		
		# Start roar exactly when fade completes
		if fade_timer >= FADE_DURATION and state == "roar":
			animated_sprite.play("roar")

	# Roar then chase
	if state == "roar":
		velocity.x = 0
		if animated_sprite.animation == "roar" and animated_sprite.is_playing():
			roar_timer += delta
			if roar_timer >= ROAR_DURATION:
				state = "chase"
				animated_sprite.play("chase")
				player.start_running()

	elif state == "chase":
		if player.global_position.x > global_position.x:
			velocity.x = SPEED

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	move_and_slide()
