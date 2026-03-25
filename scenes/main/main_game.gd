class_name MainGame
extends Node2D

static var singleton: MainGame:
	get:
		return _singleton
static var _singleton: MainGame = null

@onready var _player: Player = $Player
@onready var _moss_slug: MossSlug = $MossSlug
@onready var _map: Map = $Map

var _slug_start_y: float = 0.0

var _death_scene: PackedScene = preload("res://ui/death/death_scene.tscn")
var _dead: bool = false

const PLAYER_VELOCITY: float = 100.00
const SLUG_VELOCITY: float = 90.00

func _enter_tree() -> void:
	if singleton == null:
		_singleton = self

func _exit_tree() -> void:
	if singleton == self:
		_singleton.queue_free()

func _ready() -> void:
	_map.change_velocity(PLAYER_VELOCITY)
	
	SignalBus.obstacle_collided.connect(_on_obstacle_collided)
	SignalBus.obstacle_cleared.connect(_on_obstacle_cleared)
	_moss_slug.caught_player.connect(_on_moss_slug_caught_player)
	_slug_start_y = _moss_slug.position.y

func _physics_process(_delta: float) -> void:
	_moss_slug.target = _player.global_position
	_moss_slug.velocity = Vector2(0, SLUG_VELOCITY - _map.get_velocity())
	

func _on_moss_slug_caught_player() -> void:
	if not _dead:
		_dead = true
		scene_switcher(_death_scene)


func _on_obstacle_collided(obstacle: ObstacleTile) -> void:
	if obstacle.is_in_group("Holes"):
		print("[MainGame]: Player fell in a hole! Game Over!")


func _on_obstacle_cleared(_obstacle: ObstacleTile) -> void:
	pass

func scene_switcher(scene: PackedScene) -> void:
	get_tree().root.add_child(scene.instantiate())
	get_tree().create_timer(1.5).timeout.connect(queue_free)
