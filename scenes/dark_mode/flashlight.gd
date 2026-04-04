class_name Flashlight
extends Node2D

@export var enabled: bool = false
@export_range(1, 20, 0.01, "suffix:°/s²") var acceleration: float = 20.0
@export_range(1, 10, 0.01, "suffix:°/s") var velocity: float = 3.0

var _target_velocity: float = 0.0
var _current_velocity: float = 0.0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	visible = enabled
	
	if not enabled:
		return
		
	var target_pos: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	var angle_to: float = get_angle_to(target_pos)
	
	_target_velocity = clamp(angle_to * 10, -velocity, velocity)
	
	_calc_acceleration(delta)
	
	rotation += _current_velocity * delta


func flicker() -> void:
	var tween: Tween = get_tree().create_tween()
	
	for i: int in randi_range(1, 2):
		tween.tween_property(self, "enabled", false, randf_range(0.05, 0.3))
		tween.tween_property(self, "enabled", true, 0.1)
	

func _calc_acceleration(delta: float) -> void:
	if _target_velocity > _current_velocity:
		# Increasing velocity
		_current_velocity = min(
				_current_velocity + (acceleration * delta),
				_target_velocity)
				
	elif _target_velocity < _current_velocity:
		# Decreasing velocity
		_current_velocity = max(
				_current_velocity - (acceleration * delta),
				_target_velocity)


func _on_flicker_timer_timeout(source: Timer) -> void:
	source.start(randf_range(1.0, 10.0))
	
	if enabled:
		flicker()
	
