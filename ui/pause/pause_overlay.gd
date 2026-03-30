extends CanvasLayer

@onready var _blocker: Control = $Blocker

var _paused: bool = false


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	_blocker.visible = false
	_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE


func _exit_tree() -> void:
	if _paused:
		get_tree().paused = false
		_paused = false


func _unhandled_input(event: InputEvent) -> void:
	if not event is InputEventKey:
		return
	var key_event: InputEventKey = event as InputEventKey
	if not key_event.pressed or key_event.echo:
		return
	if key_event.keycode != KEY_ESCAPE and key_event.physical_keycode != KEY_ESCAPE:
		return
	get_viewport().set_input_as_handled()
	if _paused:
		_resume()
	else:
		_pause()


func _pause() -> void:
	_paused = true
	get_tree().paused = true
	_blocker.visible = true
	_blocker.mouse_filter = Control.MOUSE_FILTER_STOP


func _resume() -> void:
	_paused = false
	get_tree().paused = false
	_blocker.visible = false
	_blocker.mouse_filter = Control.MOUSE_FILTER_IGNORE
