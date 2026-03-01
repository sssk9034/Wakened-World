extends Area2D

@export var delay_frames := 18  # how many frames behind the player to follow
@export var speed := 150

var player

func _ready():
	player = get_node("../Player")  # adjust path as needed

func _process(delta):
	
	
	
	
	#var history = player.position_history
	
	

	if player.position_history.size() > delay_frames:
		var target_pos = player.position_history[0]
		player.position_history.pop_front()
		
		var direction = (target_pos - global_position).normalized()

		# Movement
		global_position += direction * speed * delta

		# Animation
		if direction.x > 0.1:
			$Character.frame = 5
		elif direction.x < -0.1:
			$Character.frame = 4
		else:
			$Character.frame = 6
