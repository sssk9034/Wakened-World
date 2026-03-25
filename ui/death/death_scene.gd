extends CanvasLayer

@onready var _root_node: Node = get_tree().root
var _main_scene: PackedScene = load("res://scenes/main/main_game.tscn")
@onready var _fade_animation: AnimationPlayer = $FadeAnimation


func _ready() -> void:
	await _fade_animation_func()
	

func _fade_animation_func() -> void:
	_fade_animation.play("FadeAnimation")
	await _fade_animation.animation_finished

func _fade_animation_reverse() -> void:
	_fade_animation.play_backwards("FadeAnimation")
	await _fade_animation.animation_finished


func _on_texture_button_pressed() -> void:
	_root_node.add_child(_main_scene.instantiate())
	await _fade_animation_reverse()
	queue_free()
