extends CanvasLayer

var _main_scene: PackedScene = load("res://scenes/main/main_game.tscn")

@onready var _fade_animation: AnimationPlayer = $FadeAnimation
@onready var _start_button: TextureButton = $Control/MarginContainer/CenterContainer/GridContainer/StartButton
@onready var _seed_edit: LineEdit = $Control/MarginContainer/CenterContainer/GridContainer/SeedEdit
@onready var _dark_toggle: CheckButton = $Control/MarginContainer/CenterContainer/GridContainer/DarkMode
@onready var _rng_controller: ProceduralRNGController = $ProceduralRNGController

var _press_tween: Tween
var _ui_transitioning: bool = false
var _keyboard_button_down: bool = false

func _ready() -> void:
	_start_button.resized.connect(_refresh_button_pivot)
	_refresh_button_pivot()
	_disable_start_button()
	await _fade_animation_func()

func _refresh_button_pivot() -> void:
	if _start_button.size.x <= 0.0 or _start_button.size.y <= 0.0:
		return
	_start_button.pivot_offset = _start_button.size * 0.5

func _kill_press_tween() -> void:
	if _press_tween != null and _press_tween.is_valid():
		_press_tween.kill()
	_press_tween = null

func _disable_start_button() -> void:
	_keyboard_button_down = false
	_kill_press_tween()
	_start_button.disabled = true
	_start_button.modulate = Color(1, 1, 1, 0)
	_start_button.scale = Vector2.ONE

func _fade_start_button() -> void:
	_refresh_button_pivot()
	_start_button.disabled = false
	get_tree().create_tween() \
		.tween_property(_start_button, "modulate", Color.WHITE, 0.5)

func _fade_animation_func() -> void:
	_fade_animation.play("FadeAnimation")
	await _fade_animation.animation_finished
	_fade_start_button()

func _fade_animation_reverse() -> void:
	_fade_animation.play_backwards("FadeAnimation")
	await _fade_animation.animation_finished


func _on_start_button_button_down() -> void:
	if _start_button.disabled:
		return
	_kill_press_tween()
	_press_tween = create_tween()
	_press_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_press_tween.tween_property(_start_button, "scale", Vector2(0.94, 0.94), 0.07)


func _on_start_button_button_up() -> void:
	if _start_button.disabled:
		return
	_kill_press_tween()
	_press_tween = create_tween()
	_press_tween.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	_press_tween.tween_property(_start_button, "scale", Vector2.ONE, 0.1)


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("confirm_menu"):
		if event is InputEventKey and (event as InputEventKey).echo:
			return
		if _ui_transitioning or _start_button.disabled:
			return
		_keyboard_button_down = true
		_on_start_button_button_down()
		get_viewport().set_input_as_handled()
		return

	if event.is_action_released("confirm_menu"):
		if not _keyboard_button_down:
			return
		_keyboard_button_down = false
		get_viewport().set_input_as_handled()
		if _ui_transitioning or _start_button.disabled:
			return
		_on_start_button_button_up()
		await _on_start_button_pressed()


func _on_start_button_pressed() -> void:
	if _ui_transitioning:
		return
	_ui_transitioning = true
	
	# Set seed
	_rng_controller.procedural_rng.rng_seed = _seed_edit.text
	
	# Set dark mode
	Settings.dark_mode_enabled = _dark_toggle.button_pressed
	
	var game: MainGame = _main_scene.instantiate()
	
	get_tree().root.add_child(game)
	await _fade_animation_reverse()
	queue_free()
