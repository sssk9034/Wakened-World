class_name MapTileStart
extends MapTile


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var area: Area2D = Area2D.new()
	area.collision_layer = 0
	area.collision_mask = 4
	area.monitorable = false
	var collision: CollisionShape2D = CollisionShape2D.new()
	var shape: RectangleShape2D = RectangleShape2D.new()
	shape.size = Vector2(200, 358)
	collision.shape = shape
	collision.position = Vector2(0, 179)
	area.add_child(collision)
	area.body_entered.connect(_on_body_entered)
	add_child(area)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		MainGame.singleton._on_player_enter_intro_scene(self)
