class_name ObstacleFilter
extends Resource

@export_group("Sizes")
## Sizes to allow. If empty, allows everything.
@export var allowed_sizes: Array[ObstacleType.ObstacleSizes] = []:
	set(value):
		allowed_sizes = value
		emit_changed()
## Sizes to exclude. If empty, allows everything.
@export var excluded_sizes: Array[ObstacleType.ObstacleSizes] = []:
	set(value):
		excluded_sizes = value
		emit_changed()

@export_group("Actions")
## Actions to allow. If empty, allows everything.
@export var allowed_actions: Array[ObstacleType.ObstacleActions] = []:
	set(value):
		allowed_actions = value
		emit_changed()
## Actions to exclude. If empty, allows everything.
@export var excluded_actions: Array[ObstacleType.ObstacleActions] = []:
	set(value):
		excluded_actions = value
		emit_changed()

## Returns true if the obstacle type is allowed.
func test(type: ObstacleType) -> bool:
	return (
		_test_allowed(type.size, allowed_sizes)
		and _test_exclude(type.size, excluded_sizes)
		and _test_allowed(type.action, allowed_actions)
		and _test_exclude(type.action, excluded_actions)
	)

## ANDs this and another filter together and returns a new filter.
## For allowed values (whitelist) both values must exist in both filters (AND).
## For excluded values (blacklist) only one value has to exist (OR).
func filter_and(other: ObstacleFilter) -> ObstacleFilter:
	var new: ObstacleFilter = ObstacleFilter.new()
	
	new.allowed_sizes = _and_array(allowed_sizes, other.allowed_sizes)
	new.excluded_sizes = _or_array(excluded_sizes, other.excluded_sizes)
	new.allowed_actions = _and_array(allowed_actions, other.allowed_actions)
	new.excluded_actions = _or_array(excluded_actions, other.excluded_actions)
	
	return new
	
## Returns true if value is allowed.
func _test_allowed(value: Variant, array: Array) -> bool:
	return array.size() <= 0 or value in array
	

## Returns false if value is excluded.
func _test_exclude(value: Variant, array: Array) -> bool:
	return array.size() <= 0 or not value in array

	
func _and_array(a: Array, b: Array) -> Array:
	var new: Array = []
	
	for e: Variant in a:
		if b.has(e):
			new.append(e)
	
	return new

func _or_array(a: Array, b: Array) -> Array:
	var new: Array = a.duplicate()
	
	for e: Variant in b:
		if not new.has(e):
			new.append(e)
	
	return new
