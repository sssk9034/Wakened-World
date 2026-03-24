class_name ObstacleType
extends Resource

enum ObstacleSizes {
	SMALL, ## Less than 1/4 of path width
	MEDIUM, ## About 1/4 to 1/2 of path width
	LARGE, ## Bigger than 1/2 of path width
}

enum ObstacleActions {
	NONE, ## Only prevents the player from moving through it.
	BOOST, ## Speeds up the player if they touch the obstacle.
	HINDRANCE, ## Slows down the player of they touch the obstacle.
	DEATH, ## Ends the game if the player touches the obstacle.
}

## Collision size of the obstacle.
@export var size: ObstacleSizes = ObstacleSizes.SMALL:
	set(value):
		size = value
		emit_changed()
## Affect on gameplay of the obstacle.
@export var action: ObstacleActions = ObstacleActions.NONE:
	set(value):
		action = value
		emit_changed()

## Obstacles that are allowed to be placed "next to" this obstacle.
## Obstacles are defined as being "next to" another obstacle if there
## ObstaclePosition.position_id's are the same.
## If empty, no obstacles are allowed next to this obstacle.
## Ex. If this obstacle prevents the player from moving through it
## then it should only allow boost or hindrances next to it. 
@export var allowed_next_to: ObstacleFilter:
	set(value):
		allowed_next_to = value
		emit_changed()
