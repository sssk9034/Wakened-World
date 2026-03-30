class_name Player

extends CharacterBody2D

signal reached_computer_target
signal intro_finished
signal exit_finished

static var singleton: Player:
	get:
		return _singleton
static var _singleton: Player = null

@export var speed: int = 200

@onready var character: AnimatedSprite2D = $Character

@onready var _fall_animation: AnimationPlayer = $FallAnimation

var can_user_control: bool = true
@export var computer_target: Vector2

var _auto_walk_active: bool = false

var _intro_world_position_locked: bool = false
var _intro_lock_global_position: Vector2

var _death_scene: PackedScene = preload("res://ui/death/hole_death_scene.tscn")

var dead: bool = false

func _enter_tree() -> void:
	if singleton != null:
		_singleton.queue_free()
	_singleton = self

func _exit_tree() -> void:
	if singleton == self:
		_singleton.queue_free()
		_singleton = null

func _ready() -> void:
	_fall_animation.set_current_animation("")
	character.animation_finished.connect(_on_character_animation_finished)


func _on_character_animation_finished() -> void:
	if dead or can_user_control:
		return
	if character.animation == &"exit":
		exit_finished.emit()
		return
	if character.animation != &"intro":
		return
	_intro_world_position_locked = false
	character.offset = Vector2.ZERO
	character.animation = &"straight"
	can_user_control = true
	intro_finished.emit()


func lock_intro_world_position() -> void:
	_intro_lock_global_position = global_position
	_intro_world_position_locked = true


func _physics_process(delta: float) -> void:
	if _intro_world_position_locked:
		global_position = _intro_lock_global_position
		velocity = Vector2.ZERO
		return
	if can_user_control:
		var input: float = Input.get_axis("player_left", "player_right")
		update_character_animation(input)
		velocity.x = input * speed
	
		move_and_slide()
		position.y = 0
	elif _auto_walk_active:
		position = position.move_toward(computer_target, delta * speed)
		if position.is_equal_approx(computer_target):
			position = computer_target
			_auto_walk_active = false
			reached_computer_target.emit()


func start_auto_walk() -> void:
	_auto_walk_active = true

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
	start_auto_walk()
	_fall_animation.play("HoleFall")

func _on_fall_animation_animation_finished(_anim_name: StringName) -> void:
	MainGame.singleton.scene_switcher(_death_scene)
