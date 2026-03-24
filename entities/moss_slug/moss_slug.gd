extends Area2D

@onready var character: AnimatedSprite2D = $Character
@onready var drag_path: AnimatedSprite2D = $DragPath

var _collision_shapes: Dictionary = {}
var _active_shape: CollisionPolygon2D = null


func _ready() -> void:
	for child: Node in get_children():
		if child is CollisionPolygon2D:
			_collision_shapes[child.name] = child
			child.disabled = true

	character.animation_changed.connect(_update_collision_shape)
	_update_collision_shape()


func _update_collision_shape() -> void:
	if _active_shape != null:
		_active_shape.disabled = true

	var key: String = "Col_%s" % character.animation
	_active_shape = _collision_shapes.get(key) as CollisionPolygon2D

	if _active_shape != null:
		_active_shape.disabled = false
