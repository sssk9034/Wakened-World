extends CanvasLayer

var _main_scene: PackedScene = load("res://scenes/main/main_game.tscn")

@onready var _fade_animation: AnimationPlayer = $FadeAnimation
@onready var _retry_button: Button = $Control/VBoxContainer/AspectRatioContainer/MarginContainer/Button

func _ready() -> void:
	_disable_retry_button()
	await _fade_animation_func()
	
func _disable_retry_button() -> void:
	_retry_button.disabled = true
	_retry_button.modulate = Color(1, 1, 1, 0)
	
func _fade_retry_button() -> void:
	_retry_button.disabled = false
	get_tree().create_tween() \
		.tween_property(_retry_button, "modulate", Color.WHITE, 0.5)

func _fade_animation_func() -> void:
	_fade_animation.play("FadeAnimation")
	await _fade_animation.animation_finished
	_fade_retry_button()
	

func _fade_animation_reverse() -> void:
	_fade_animation.play_backwards("FadeAnimation")
	await _fade_animation.animation_finished


func _on_button_pressed() -> void:
	get_tree().root.add_child(_main_scene.instantiate())
	await _fade_animation_reverse()
	queue_free()
