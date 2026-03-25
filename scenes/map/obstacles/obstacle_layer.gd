@tool
class_name ObstacleLayer
extends Node2D

## Layout to use to place obstacles. Can be empty.
@export var obstacle_layout: ObstacleLayout:
	set(value):
		if Engine.is_editor_hint():
			if obstacle_layout != null:
				obstacle_layout.changed.disconnect(queue_redraw)
			if value != null:
				value.changed.connect(queue_redraw)
		obstacle_layout = value
		queue_redraw()

var tile_count: int:
	get:
		return _tile_count
var _tile_count: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if not Engine.is_editor_hint() and obstacle_layout != null:
		while obstacle_layout.has_next_obstacle():
			var obstacle: ObstacleTile = obstacle_layout.get_next_obstacle()
			add_child(obstacle)


func _draw() -> void:
	if Engine.is_editor_hint() and obstacle_layout != null:
		obstacle_layout.draw_layout(self)


## Appends the given tile to the layer.
func add_tile(tile: ObstacleTile) -> void:
	add_child(tile)
	_tile_count += 1
	

## Clears all tiles from the layer.
func clear() -> void:
	for n: Node in get_children():
		#remove_child(n)
		n.queue_free()

	_tile_count = 0
	
	
## Returns true if there are no tiles placed in this layer.
func is_empty() -> bool:
	return _tile_count <= 0
	
