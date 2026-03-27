class_name ObstacleBuilder
extends Resource

@export var obstacle_list: Array[PackedScene]:
	set(value):
		var arr: Array[PackedScene] = []
		_instantiated_obstacles.clear()
		
		for scene: PackedScene in value:
			var instantiated: ObstacleTile = scene.instantiate()
			if instantiated.type == null:
				printerr("[ObstacleBuilder]: Invalid obstacle: %s, missing ObstacleType" % [instantiated.name])
				continue
			arr.append(scene)
			_instantiated_obstacles.append(instantiated)
			
		obstacle_list = arr

@export var blank_obstacle: PackedScene:
	set(value):
		blank_obstacle = value
		_instantiated_blank_obstacle = value.instantiate()
			
var _instantiated_obstacles: Array[ObstacleTile]
var _instantiated_blank_obstacle: ObstacleTile

## Instantiates a new obstacle with the given index.
## If the index is -1, instantiates a blank obstacle.
func get_new_obstacle(index: int) -> ObstacleTile:
	if index <= -1:
		return blank_obstacle.instantiate()
	
	return obstacle_list[index].instantiate()


## Returns a read-only obstacle to use for filtering.
## If the index is -1, returns a blank obstacle.
func get_obstacle(index: int) -> ObstacleTile:
	if index <= -1:
		return _instantiated_blank_obstacle
	
	return _instantiated_obstacles[index]


func get_count() -> int:
	return obstacle_list.size()
