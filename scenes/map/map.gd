extends Node2D
## Handles smooth map movement.
##
## Map movement is done once per frame.
## Map changes in velocity are also calculated once per frame.
## 
## Velocity may be updated either one of two ways:
## change_velocity(new_velocity: float) -> void
##		Smoothly changes the maps velocity using the defined acceleration values.
##
## set_velocity(new_velocity: float) -> void
##		Instantly changes the maps velocity, (aka, infinite acceleration)

@export var acceleration: float = 100.0 # pixels/sec^2
@export var deceleration: float = 200.0 # pixels/sec^2
@export var velocity: float = 100.0 # pixels/sec

var _current_velocity: float = 0.0 # pixels/sec


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	_update_velocity(delta)
	_update_map_position(delta)
	

## Smoothly changes velocity to new_velocity by acceleration values.
func change_velocity(new_velocity: float) -> void:
	velocity = new_velocity


## Instantly changes velocity to new_velocity.
func set_velocity(new_velocity: float) -> void:
	velocity = new_velocity
	_current_velocity = new_velocity


## Updates velocity if _current_velocity != velocity, using acceleration values.
func _update_velocity(delta: float) -> void:
	if velocity > _current_velocity:
		# Increasing velocity
		_current_velocity = min(
				_current_velocity + (acceleration * delta),
				velocity)
				
	elif velocity < _current_velocity:
		# Decreasing velocity
		_current_velocity = max(
				_current_velocity - (deceleration * delta),
				velocity)
	

## Moves map by current_velocity
func _update_map_position(delta: float) -> void:
	move_local_y(-_current_velocity * delta, false)
	
