class_name Player

extends CharacterBody2D

static var singleton: Player:
	get:
		return _singleton
static var _singleton: Player = null

@export var speed: int = 200

@onready var character: AnimatedSprite2D = $Character

@onready var _fall_animation: AnimationPlayer = $FallAnimation

var can_user_control: bool = true
@export var computer_target: Vector2

var _death_scene: PackedScene = preload("res://ui/death/hole_death_scene.tscn")

var dead: bool = false

func _enter_tree() -> void:
	if singleton == null:
		_singleton = self

func _exit_tree() -> void:
	if singleton == self:
		_singleton.queue_free()

func _ready() -> void:
	_fall_animation.set_current_animation("")


func _physics_process(delta: float) -> void:
	if can_user_control:
		var input: float = Input.get_axis("player_left", "player_right")
		update_character_animation(input)
		velocity.x = input * speed
	
		move_and_slide()
		position.y = 0
	elif computer_target != null:
		position = position.move_toward(computer_target, delta * speed)

func is_at_target() -> bool:
	return position.is_equal_approx(computer_target)  

func update_character_animation(direction: float) -> void:
	if direction > 0:
		character.animation = "right"
	elif direction < 0:
		character.animation = "left"
	else:
		character.animation = "straight"

func trigger_hole_death(hole_position: Vector2) -> void:
	if dead:
		return
	dead = true
	
	computer_target = hole_position
	can_user_control = false
	_fall_animation.play("HoleFall")

func _on_fall_animation_animation_finished(_anim_name: StringName) -> void:
	MainGame.singleton.scene_switcher(_death_scene)
