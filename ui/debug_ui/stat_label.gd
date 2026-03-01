class_name StatLabel
extends Label

enum StatType {
	PERFORMANCE_MONITOR,
	PERFORMANCE_CUSTOM_MONITOR,
	CALLABLE,
	STATIC_TEXT,
}

@export var type: StatType
@export var prefix_str: String = ""
@export var postfix_str: String = ""
@export var monitor: Performance.Monitor
@export var custom_monitor: StringName
@export var callable: Callable
@export var format_string: String = "%.01f"
@export var update_frames: int = 15

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Only update if visable
	if not is_visible_in_tree():
		return
	
	# Only update every update_frames
	if (Engine.get_process_frames() % update_frames) != 0:
		return
	
	text = prefix_str
	
	match type:
		StatType.PERFORMANCE_MONITOR:
			text += (format_string 
					% Performance.get_monitor(monitor))
					
		StatType.PERFORMANCE_CUSTOM_MONITOR:
			text += (format_string 
					% Performance.get_custom_monitor(custom_monitor))
		
		StatType.CALLABLE:
			text += format_string % callable.call()
		
	text += postfix_str
	
