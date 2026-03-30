class_name MapTileStart
extends MapTile

const ANIMATED_SPRITE_TARGET_X: float = -411.0
const ANIMATED_SPRITE_MOVE_DURATION_SEC: float = 2.0

@onready var _moss_slug_chasing: AnimatedSprite2D = $MossSlugChasing


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
	_start_animated_sprite_horizontal_move()


func _start_animated_sprite_horizontal_move() -> void:
	var target: Vector2 = Vector2(ANIMATED_SPRITE_TARGET_X, _moss_slug_chasing.position.y)
	var tw: Tween = create_tween()
	tw.tween_property(_moss_slug_chasing, "position", target, ANIMATED_SPRITE_MOVE_DURATION_SEC) \
		.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_SINE)


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		MainGame.singleton._on_player_enter_intro_scene(self)
