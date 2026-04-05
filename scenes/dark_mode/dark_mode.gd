class_name DarkMode
extends Node2D

@export var enabled: bool = false
@export var player: Node2D

@onready var _flashlight: Flashlight = $Flashlight
@onready var _canvas_modulate: CanvasModulate = $CanvasModulate

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if not enabled:
		visible = false
		process_mode = Node.PROCESS_MODE_DISABLED
	
	# Update position of player lights
	_flashlight.global_position = player.global_position


func switch_to_player_light() -> void:
	if not enabled:
		return
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_canvas_modulate, "color", Color(0.0, 0.0, 0.0, 1.0), 2.5)
	tween.tween_property(_flashlight, "enabled", true, 0)
	tween.tween_callback(_flashlight.flicker)
		
func switch_to_game_light() -> void:
	if not enabled:
		return
	
	var tween: Tween = get_tree().create_tween()
	tween.tween_property(_canvas_modulate, "color", Color(0.282, 0.282, 0.282, 1.0), 2.5)
	tween.tween_property(_flashlight, "enabled", false, 0)
