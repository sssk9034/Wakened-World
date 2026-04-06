@tool
class_name ProceduralObstacleLayout
extends ObstacleLayout

@export var positions: Array[ProceduralObstaclePosition]:
	set(value):
		var pos: Array[ObstaclePosition] = []
		pos.assign(value)
		_positions = pos
	get:
		var pos: Array[ProceduralObstaclePosition] = []
		pos.assign(_positions)
		return pos
		
@export var obstacle_builder: ObstacleBuilder
@export var obstacle_rng: ProceduralRNG

var _positions_index: int = 0
var _position_ids_list: Dictionary[int, Array] = {} # Array[ObstacleType]

func get_next_obstacle() -> ObstacleTile:
	const BLANK_TILE_INDEX: int = -1
	var tile: ObstacleTile
	var pos: ProceduralObstaclePosition = positions[_positions_index]
	_positions_index += 1
		
	var candidate_obstacles: PackedInt32Array # List of indices
	var candidate_weights: PackedFloat32Array
	
	# Add blank obstacle
	candidate_obstacles.append(BLANK_TILE_INDEX)
	candidate_weights.append(obstacle_builder.get_obstacle(BLANK_TILE_INDEX).probability)
	
	for i: int in obstacle_builder.get_count():
		var candidate_obstacle: ObstacleTile = obstacle_builder.get_obstacle(i)
		
		# Ensure allowed_next_to is not null if we are placing next to another
		# obstacle. If it is, then this obstacle is not allowed to be placed
		if (candidate_obstacle.type.allowed_next_to == null
				and _position_ids_list.has(pos.position_id)):
			continue
		
		# Check if candidate_obstacle is allowed at this position
		# If allowed_types is null, all obstacles are allowed
		if pos.allowed_types != null and not pos.allowed_types.test(candidate_obstacle.type):
			# Not allowed
			continue
		
		var allowed: bool = true
		for placed_obstacle: ObstacleType in _position_ids_list.get(pos.position_id, []):
			# Ensure allowed_next_to is not null
			# If it is, then no obstacle is allowed to be placed next to this one
			if placed_obstacle.allowed_next_to == null:
				allowed = false
				break
			
			# Check if candidate_obstacle is allowed next to placed_obstacle
			if not placed_obstacle.allowed_next_to.test(candidate_obstacle.type):
				allowed = false
				break
			
			# Check if placed_obstacle is allowed next to the candidate_obstacle
			if not candidate_obstacle.type.allowed_next_to.test(placed_obstacle):
				allowed = false
				break
				
		if allowed:
			candidate_obstacles.append(i)
			candidate_weights.append(candidate_obstacle.probability)

	var tile_index: int
	if candidate_obstacles.size() == 1:
		# Shortcut if there is only 1 possible option, dont involve the rng
		tile_index = candidate_obstacles[0]
	else:
		tile_index = candidate_obstacles[obstacle_rng.rand_weighted(candidate_weights)]
		
	tile = obstacle_builder.get_new_obstacle(tile_index)
	
	tile.position = pos.get_position()
	
	if tile.rotatable:
		tile.rotation = pos.get_rotation()
	
	# If position_id is -1, then it is not considered to be "next to" any other obstacle.
	# If tile_index is equal to BLANK_TILE_INDEX then the obstacle is not "next to" anything,
	# so dont add anything.
	if pos.position_id >= 0 and tile_index != BLANK_TILE_INDEX:
		var arr: Array = _position_ids_list.get_or_add(pos.position_id, [])
		arr.append(tile.type)
	
	return tile
	
	
func has_next_obstacle() -> bool:
	return _positions_index < positions.size()


## Draws an obstacles position. Mostly used in editor for viewing layout.
func draw_obstacle(canvas: CanvasItem, obstacle: ObstaclePosition) -> void:
	super(canvas, obstacle)
	
	var procedural_obstacle: ProceduralObstaclePosition = obstacle as ProceduralObstaclePosition
	
	if procedural_obstacle.position_id >= 0:
		canvas.draw_string(
			ThemeDB.fallback_font,
			Vector2(3, -8),
			"%d" % [procedural_obstacle.position_id],
			HORIZONTAL_ALIGNMENT_CENTER,
			-1,
			10,
			Color(1.0, 0.0, 0.0, 1.0))
