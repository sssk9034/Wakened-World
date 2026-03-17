class_name Map
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

const MAPTILE_STRAIGHT: PackedScene = preload("res://scenes/map/map_tiles/tiles/map_tile_straight_1.tscn")
const MAPTILE_DIAGONAL: PackedScene = preload("res://scenes/map/map_tiles/tiles/map_tile_diagonal_left_1.tscn")

const TILES_PER_MAP_LAYER: int = 10

@export_group("Generation")
@export var map_seed: String = ""
## Set to 0 to generate based on map_seed
@export_range(0, 100, 1, "or_greater") var map_length: int = 0 

@export_group("Movement")
@export_range(1, 500, 0.01, "suffix:px/s²") var acceleration: float = 100.0
@export_range(1, 500, 0.01, "suffix:px/s²") var deceleration: float = 200.0
@export_range(0, 200, 0.01, "suffix:px/s") var velocity: float = 100.0

var _target_velocity: float = 0.0 # pixels/sec
var _target_velocity_modifiers: Array[VelocityModifier] = []
var _current_velocity: float = 0.0 # pixels/sec
var _current_velocity_modifiers: Array[VelocityModifier] = []

var _rng_seed: int = 0
var _rng_use_seed: bool = false

@onready var _leading_map_layer: MapLayer = $MapLayer1
@onready var _following_map_layer: MapLayer = $MapLayer2


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_map_seed()
	_update_map_length()
	# TODO Trigger initial build


# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	_target_velocity = velocity
	
	# Apply target velocity modifiers
	for mod: VelocityModifier in _target_velocity_modifiers:
		_target_velocity = mod.mod_velocity(_target_velocity, velocity)
	
	_calc_acceleration(delta)
	
	# Apply current velocity modifers
	for mod: VelocityModifier in _current_velocity_modifiers:
		_current_velocity = mod.mod_velocity(_current_velocity, velocity)
	
	_current_velocity = max(_current_velocity, 0) # Prevent moving backward
	
	if _check_for_layer_swap():
		print("[Map]: Swapping MapLayers")
		_leading_map_layer.clear()
		
		var map_layer: MapLayer = _leading_map_layer
		_leading_map_layer = _following_map_layer
		_following_map_layer = map_layer
		
		_update_map_layer_position(delta)
		
		# TODO trigger build of following
		
		
	else:
		_update_map_layer_position(delta)
		

## Smoothly changes velocity to new_velocity by acceleration values.
func change_velocity(new_velocity: float) -> void:
	velocity = new_velocity


## Instantly changes velocity to new_velocity.
func set_velocity(new_velocity: float) -> void:
	velocity = new_velocity
	_current_velocity = new_velocity


## Adds a velocity modifier to the target velocity modifiers.
## Will be sorted in order of VelocityModifier.priority, from smallest to
## greatest.
func add_target_velocity_modifier(modifier: VelocityModifier) -> void:
	_add_velocity_modifier(modifier, _target_velocity_modifiers)


## Adds a velocity modifier to the current velocity modifiers.
## Will be sorted in order of VelocityModifier.priority, from smallest to
## greatest.
func add_current_velocity_modifier(modifier: VelocityModifier) -> void:
	_add_velocity_modifier(modifier, _current_velocity_modifiers)


## Removes a velocity modifier from the target velocity modifiers.
## Prints an error if the modifier is not in the list.
func remove_target_velocity_modifier(modifier: VelocityModifier) -> void:
	_remove_velocity_modifier(modifier, _target_velocity_modifiers)


## Removes a velocity modifier from the current velocity modifiers.
## Prints an error if the modifier is not in the list.
func remove_current_velocity_modifier(modifier: VelocityModifier) -> void:
	_remove_velocity_modifier(modifier, _current_velocity_modifiers)


## Adds a velocity modifer to the given array.
func _add_velocity_modifier(modifier: VelocityModifier, array: Array[VelocityModifier]) -> void:
	var index: int = array.bsearch_custom(
			modifier, VelocityModifier.sort_priority, false)
	array.insert(index, modifier)
	

# Removes a velocity modifer from the given array
func _remove_velocity_modifier(modifier: VelocityModifier, array: Array[VelocityModifier]) -> void:
	var index: int = array.find(modifier)
	
	if index <= -1:
		printerr("[Map]: VelocityModifier was not found on remove (priority: %d)"
				% [modifier.priority])
		return
	
	array.remove_at(index)


## Updates _target_velocity if _current_velocity != _target_velocity, using acceleration values.
func _calc_acceleration(delta: float) -> void:
	if _target_velocity > _current_velocity:
		# Increasing velocity
		_current_velocity = min(
				_current_velocity + (acceleration * delta),
				_target_velocity)
				
	elif _target_velocity < _current_velocity:
		# Decreasing velocity
		_current_velocity = max(
				_current_velocity - (deceleration * delta),
				_target_velocity)
	

## Moves map by current_velocity
func _update_map_layer_position(delta: float) -> void:
	_leading_map_layer.move_local_y(-_current_velocity * delta, false)
	_following_map_layer.position = _leading_map_layer.get_end_position()
	

## Check if _leading_map_layer is fully off screen.
## This happens when _following_map_layer.global_position.y is above the camera.
func _check_for_layer_swap() -> bool:
	#var pos: float = get_viewport().get_camera_2d().get_screen_center_position().y
	#var offset: float = (get_viewport_rect().size.y / get_viewport().get_camera_2d().zoom.y) / 2
	
	# Optimizations based on assumptions
	# Since the camera should always be at y = 0
	const pos: float = 0.0
	# Camera zoom should never be less than 0.5
	var offset: float = get_viewport_rect().size.y

	return _following_map_layer.global_position.y < (pos - offset)
	

## Updates the rng seed if map_seed is not empty, otherwise uses a random seed.
func _update_map_seed() -> void:
	if map_seed:
		_rng_seed = map_seed.hash()
		_rng_use_seed = true
		print("[Map]: Using seed: %s (%d)" % [map_seed, _rng_seed])
	else:
		print("[Map]: No seed provided, using random seed.")
		_rng_use_seed = false
		

## Updates the map length.
## If map_length is <= 0 then the length is determine by summing the ord()
## of all the characters in map_seed.
## If map_length is >= 1 then it is used as the map_length
func _update_map_length() -> void:
	if map_length <= 0:
		# Generate based on map_seed
		var sum: int = 0
		
		for c: String in map_seed:
			sum += ord(c)
		
		map_length = sum
		print("[Map]: Generated map length: %s" % [map_length])
	else:
		# Use specified map length
		print("[Map]: Using provided map length: %s" % [map_length])
	

## Class for changing map velocity, without having to save the original.
## Primarily to prevent conflics when two systems change the velocity.
@abstract
class VelocityModifier:
	## Sets the order in which modifiers will be applied. Modifiers with lower
	## priority are applied first, and higher priority is applied last.
	var priority: int = 0
	
	## Sorts based on priority value. Higher priority values will be applied last,
	## therefore giving them the ability to override other modifiers.
	static func sort_priority(a: VelocityModifier, b: VelocityModifier) -> bool:
		return a.priority < b.priority
	
	## Override to modify velocity.
	@abstract
	func mod_velocity(old_velocity: float, _original_velocity: float) -> float
	
