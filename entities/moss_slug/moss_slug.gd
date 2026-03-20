extends Area2D

@onready var character: AnimatedSprite2D = $Character
@onready var drag_path: AnimatedSprite2D = $DragPath


@export var delay_frames : int = 25  # how many frames behind the player to follow
@export var speed: int = 150 # slug speed

@export var player: Player

func _ready()-> void:
	pass

func _physics_process(delta: float) -> void:
	
	if player.position_history.size() > delay_frames:
		var target_x: float = player.position_history[0]
		player.position_history.remove_at(0)
		
		var distance: float = target_x - global_position.x

		if abs(distance) > 1.0:
			# Movement
			global_position += Vector2(distance, 0).normalized() * speed * delta

			# Animation
			if distance > 0:
				character.animation = "right"
				drag_path.animation = "right"
			elif distance < 0:
				character.animation = "left"
				drag_path.animation = "left"

		else:
			character.animation = "straight"
			drag_path.animation = "straight"
