class_name MainGame
extends Node2D

static var singleton: MainGame:
	get:
		return _singleton
static var _singleton: MainGame = null

@onready var _player: Player = $Player
@onready var _moss_slug: MossSlug = $MossSlug
@onready var _map: Map = $Map

var _death_scene: PackedScene = preload("res://ui/death/death_scene.tscn")
var _hole_death_scene: PackedScene = preload("res://ui/death/hole_death_scene.tscn")

const PLAYER_VELOCITY: float = 100.00
const SLUG_VELOCITY: float = 90.00

func _enter_tree() -> void:
	if singleton != null:
		_singleton.queue_free()
	_singleton = self

func _exit_tree() -> void:
	if singleton == self:
		_singleton.queue_free()
		_singleton = null

func _ready() -> void:
	_map.change_velocity(PLAYER_VELOCITY)
	
	_moss_slug.caught_player.connect(_on_moss_slug_caught_player)

func _physics_process(_delta: float) -> void:
	_moss_slug.target = _player.global_position
	_moss_slug.velocity = Vector2(0, SLUG_VELOCITY - _map.get_velocity())

func _on_moss_slug_caught_player() -> void:
	kill_player("slug")

func scene_switcher(scene: PackedScene) -> void:
	get_tree().root.add_child(scene.instantiate())
	get_tree().create_timer(1.5).timeout.connect(queue_free)


func kill_player(cause: String) -> void:
	if _player.dead:
		return
	_player.dead = true
	
	if cause == "hole":
		on_hole_death()
	elif cause == "slug":
		on_slug_death()

func on_hole_death() -> void:
	scene_switcher(_hole_death_scene)

func on_slug_death() -> void:
	scene_switcher(_death_scene)
