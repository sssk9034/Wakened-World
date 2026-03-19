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
@onready var _draw_node: Node2D = Node2D.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		add_child(_draw_node)
		_draw_node.draw.connect(_draw_node_draw)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
	


## Returns the relative offset that the next tile should be placed at to
## connect to this tile.
func get_next_tile_offset() -> Vector2:
	return _next_tile_marker.position
	

func _draw() -> void:
	# Update draw node
	_draw_node.queue_redraw()
	

func _draw_node_draw() -> void:
	if obstacle_layout != null:
		# Draw obstacle layout
		const CROSS_SIZE: Vector2 = Vector2(10, 10)
		const ARROW_SIZE: Vector2 = Vector2(5, 5)
		
		for pos: Transform2D in obstacle_layout.get_transforms():
			print(pos)
			_draw_node.draw_line(
				pos.origin - (CROSS_SIZE * pos.x),
				pos.origin + (CROSS_SIZE * pos.x),
				Color(1.0, 0.0, 0.0))
			_draw_node.draw_line(
				pos.origin - (CROSS_SIZE * pos.y),
				pos.origin + (CROSS_SIZE * pos.y),
				Color(0.0, 1.0, 0.0))
			# Arrow
			_draw_node.draw_line(
				pos.origin + (CROSS_SIZE * pos.y),
				pos.origin + (ARROW_SIZE * pos.y) - (ARROW_SIZE * pos.x),
				Color(0.0, 1.0, 0.0))
			_draw_node.draw_line(
				pos.origin + (CROSS_SIZE * pos.y),
				pos.origin + (ARROW_SIZE * pos.y) + (ARROW_SIZE * pos.x),
				Color(0.0, 1.0, 0.0))
