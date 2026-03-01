extends Area2D

@export var delay_frames := 18  # how many frames behind the player to follow
@export var speed := 150

var player

func _ready():
	player = get_node("../Player")  # adjust path as needed

func _process(delta):
	
	
	
	
	#var history = player.position_history
	
	

	if player.position_history.size() > delay_frames:
		var target_x = player.position_history[0]
		player.position_history.pop_front()
		
		var distance = target_x - global_position.x

		if abs(distance) > 1.0:
			# Movement
			global_position += Vector2(distance, 0).normalized() * speed * delta

			# Animation
			if distance > 0:
				$Character.frame = 5
			elif distance < 0:
				$Character.frame = 4

		else:
			$Character.frame = 6
