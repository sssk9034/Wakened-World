extends CharacterBody2D

#Make Player a class name so moss slug script can init player variable as type Player
class_name Player

#Add player speed as a variable in inspector
@export var speed: int = 200

# We aren't using this variable right now but I suspect it will come in handy...maybe not
#@onready var screensize: Vector2 = get_viewport_rect().size

#create character variable for the Node as type Sprite2D
@onready var character: Sprite2D = $Character

#init position history list for moss slug script
var position_history: PackedFloat32Array = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# How we are handling movement WITH Character2DBody (using move_and_slide)
func _physics_process(_delta: float) -> void:
	move_and_slide()
	
	#Tracks player position for use in moss_slug script
	position_history.append(global_position.x)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var input: float = Input.get_axis("player_left", "player_right")

#set sprite frame to left slide for left input, right frame for right input, straight frame for no input
	if input > 0:
		character.frame = 7
	elif input < 0:
		character.frame = 6
	else:
		character.frame = 5
	
	#Update velocity
	velocity.x = input * speed
	
	if Input.is_action_just_pressed("player_left"):
		$Sliding.play_slide()

	if Input.is_action_just_pressed("player_right"):
		$Sliding.play_slide()
# How we were handling movement before using CharacterBody2D
	##apply velocity
	#position += velocity * delta
	#
	##append players position to the position history list
	#position_history.append(global_position.x)
	
	
