extends Control

const stat_label: PackedScene = preload("uid://ckng37s0a3a7p") # stat_label.tscn

@onready var stat_container: VBoxContainer = $DebugOverlay/MarginContainer2/VBoxContainer
@onready var overlay_container: MarginContainer = $DebugOverlay


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Hide by default
	overlay_container.hide()
	# Reset margin container to 0, 0 size, so it resizes automatically
	overlay_container.size = Vector2(0, 0)
	
	# Game version info
	var stat: StatLabel = stat_label.instantiate()
	stat.type = StatLabel.StatType.STATIC_TEXT
	stat.prefix_str = "%s (v%s) Debug UI" % [
			ProjectSettings.get_setting("application/config/name"),
			ProjectSettings.get_setting("application/config/version")]
	stat_container.add_child(stat)
	
	# Engine version info
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.STATIC_TEXT
	stat.prefix_str = Engine.get_version_info().string
	stat_container.add_child(stat)
	
	# Window resolution
	var window_res_callable: Callable = Callable(self, "_get_window_resolution")
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.CALLABLE
	stat.prefix_str = "Window Resolution: "
	stat.callable = window_res_callable
	stat.format_string = "%dx%d"
	stat_container.add_child(stat)
	
	# Render resolution
	var render_res_callable: Callable = Callable(self, "_get_render_resolution")
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.CALLABLE
	stat.prefix_str = "Render Resolution: "
	stat.callable = render_res_callable
	stat.format_string = "%dx%d"
	stat_container.add_child(stat)
	
	# Camera position
	var camera_pos_callable: Callable = Callable(self, "_get_camera_position")
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.CALLABLE
	stat.prefix_str = "Camera Position: "
	stat.callable = camera_pos_callable
	stat.format_string = "%dx%d"
	stat_container.add_child(stat)
	
	# Frame time
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.PERFORMANCE_MONITOR
	stat.prefix_str = "Frame time: "
	stat.postfix_str = " sec"
	stat.monitor = Performance.TIME_PROCESS
	stat.format_string = "%f"
	stat_container.add_child(stat)
	
	# Physics frame time
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.PERFORMANCE_MONITOR
	stat.prefix_str = "Physics frame time: "
	stat.postfix_str = " sec"
	stat.monitor = Performance.TIME_PHYSICS_PROCESS
	stat.format_string = "%f"
	stat_container.add_child(stat)
	
	# Frames/sec
	stat = stat_label.instantiate()
	stat.type = StatLabel.StatType.PERFORMANCE_MONITOR
	stat.prefix_str = "FPS: "
	stat.monitor = Performance.TIME_FPS
	stat_container.add_child(stat)
	

func _input(event: InputEvent) -> void:
	if event.is_action_released("open_debug_ui"):
		if overlay_container.is_visible_in_tree():
			overlay_container.hide()
		else:
			overlay_container.show()


func _get_window_resolution() -> Array[int]:
	var res: Vector2i = get_window().size
	return [res.x, res.y]
	
	
func _get_render_resolution() -> Array[int]:
	var res: Vector2i = get_viewport_rect().size
	return [res.x, res.y]
	
	
func _get_camera_position() -> Array[int]:
	var pos: Vector2i = get_viewport().get_camera_2d().global_position
	return [pos.x, pos.y]
