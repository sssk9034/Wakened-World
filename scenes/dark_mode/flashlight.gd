class_name Flashlight
extends Node2D

@export var enabled: bool = false:
	set(value):
		enabled = value
		_active = value
@export_range(1, 20, 0.01, "suffix:°/s²") var acceleration: float = 20.0
@export_range(1, 10, 0.01, "suffix:°/s") var velocity: float = 3.0

var _target_velocity: float = 0.0
var _current_velocity: float = 0.0
var _active: bool = false:
	set(value):
		_active = value
		visible = value
		
func _ready() -> void:
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not enabled:
		return
		
	var target_pos: Vector2 = get_viewport().get_camera_2d().get_global_mouse_position()
	var angle_to: float = get_angle_to(target_pos)
	
	_target_velocity = clamp(angle_to * 10, -velocity, velocity)
	
	_calc_acceleration(delta)
	
	rotation += _current_velocity * delta


func flicker() -> void:
	if not enabled:
		return
	
	var tween: Tween = get_tree().create_tween()
	
	for i: int in randi_range(1, 2):
		tween.tween_property(self, "_active", false, randf_range(0.05, 0.3))
		tween.tween_property(self, "_active", true, 0.1)
	

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


func _on_flicker_randomized_timer_timeout() -> void:
	flicker()
