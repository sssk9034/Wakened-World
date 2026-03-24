@tool
class_name ProceduralObstaclePosition 
extends ObstaclePosition
## Represents a posistion an obstacle can be placed at.
## Includes the positioning information of the obstacle, as well as what obstacles
## are allowed to be placed here.

## Links positions that are "next to" one another.
## If two or more positions have the same ID, then their ObstacleType.allowed_next_to
## is considered in placing the group. All already placed obstacles with the same ID
## will have their allowed_next_to's ANDed together and used to filter for a new
## obstacle. Once found, that obstacles allowed_next_to will then be checked against
## the existing obstacles. 
## If position_id is -1, then it is not considered to be "next to" any other obstacle.
@export var position_id: int = -1
## Filter obstacles that are allowed to be placed at this position.
## If empty, all obstacles are allowed.
@export var allowed_types: ObstacleFilter:
	set(value):
		allowed_types = value
		emit_changed()
