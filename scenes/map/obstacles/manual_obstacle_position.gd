@tool
class_name ManualObstaclePosition 
extends ObstaclePosition
## Represents a posistion an obstacle can be placed at.
## Includes the positioning information of the obstacle, as well as the PackedScene
## (ObstacleTile) to use for the obstacle

## The obstacle tile for this position.
@export var tile_scene: PackedScene:
	set(value):
		tile_scene = value
		emit_changed()
