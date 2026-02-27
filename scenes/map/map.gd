extends Node2D

@export var acceleration: float = 100 # pixels/sec^2
@export var deceleration: float = 200 # pixels/sec^2
@export var velocity: float = 100 # pixels/sec

var _current_velocity: float = 0 # pixels/sec

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_velocity(delta)
	_update_map_position(delta)
	
	
func _update_velocity(delta: float) -> void:
	if velocity > _current_velocity:
		# Increasing velocity
		_current_velocity = min(_current_velocity + (acceleration * delta), velocity)
	elif velocity < _current_velocity:
		# Decreasing velocity
		_current_velocity = max(_current_velocity - (deceleration * delta), velocity)
	
	
func _update_map_position(delta: float) -> void:
	move_local_y(-_current_velocity * delta, false)


# Smoothly changes velocity to new_velocity by acceleration values.
func change_velocity(new_velocity: float) -> void:
	velocity = new_velocity


# Instantly changes velocity to new_velocity.
func set_velocity(new_velocity: float) -> void:
	velocity = new_velocity
	_current_velocity = new_velocity
