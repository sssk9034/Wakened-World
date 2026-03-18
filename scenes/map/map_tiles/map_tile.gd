@tool
class_name MapTile
extends Node2D

@export var obstacle_layout: ObstacleLayout:
	set(value):
		if Engine.is_editor_hint():
			if obstacle_layout != null:
				obstacle_layout.changed.disconnect(queue_redraw)
			if value != null:
				value.changed.connect(queue_redraw)
		obstacle_layout = value
		queue_redraw()
@export var probability: float = 1.0

@onready var _next_tile_marker: Marker2D = $NextTileMarker

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	
func _draw() -> void:
	if Engine.is_editor_hint() and obstacle_layout != null:
		# Draw obstacle layout
		for pos: Vector2 in obstacle_layout.get_positions():
			draw_circle(pos, 2.0, Color(1.0, 0.0, 1.0, 1))

## Returns the relative offset that the next tile should be placed at to
## connect to this tile.
func get_next_tile_offset() -> Vector2:
	return _next_tile_marker.position
