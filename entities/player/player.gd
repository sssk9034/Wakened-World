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

func _enter_tree() -> void:
	if singleton == null:
		_singleton = self

func _exit_tree() -> void:
	if singleton == self:
		_singleton.queue_free()

func _ready() -> void:
	_fall_animation.set_current_animation("")

#set sprite frame to left slide for left input, right frame for right input, straight frame for no input
	if input > 0:
		character.frame = 7
	elif input < 0:
		character.frame = 6
	else:
		character.frame = 5
	
	#Update velocity
	velocity.x = input * speed
	
	if Input.is_action_just_pressed("player_left"):
		$Sliding.play_slide()

	if Input.is_action_just_pressed("player_right"):
		$Sliding.play_slide()
# How we were handling movement before using CharacterBody2D
	##apply velocity
	#position += velocity * delta
	#
	##append players position to the position history list
	#position_history.append(global_position.x)
	

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
	computer_target = hole_position
	can_user_control = false
	_fall_animation.play("HoleFall")

func _on_fall_animation_animation_finished(_anim_name: StringName) -> void:
	MainGame.singleton.scene_switcher(_death_scene)
