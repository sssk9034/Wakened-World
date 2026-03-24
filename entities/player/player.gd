extends CharacterBody2D


class_name Player

@export var speed: int = 200

@onready var character: Sprite2D = $Character


func _ready() -> void:
	$FallAnimation.set_current_animation("")


func _physics_process(_delta: float) -> void:
	move_and_slide()
	position.y = 0

	for i in range(get_slide_collision_count()):
		var collision: KinematicCollision2D = get_slide_collision(i)
		var collider: Object = collision.get_collider()

		if collider.is_in_group("Holes"):
			trigger_animation()


func trigger_animation() -> void:
	$FallAnimation.play("HoleFall")


func _process(_delta: float) -> void:
	var input: float = Input.get_axis("player_left", "player_right")

	if input > 0:
		character.frame = 7
	elif input < 0:
		character.frame = 6
	else:
		character.frame = 5

	velocity.x = input * speed
