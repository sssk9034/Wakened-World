extends TileMapLayer

const TILESET_SOURCE_ID = 1
var tile_list: Array[TileLocator] = []

@export var seed: String = ""

# might be a way to make map move instead of player.
# if camera is following player, solves corner issue

class TileLocator:
	var source_id: int
	var tile_id: Vector2i
	var alternative_tile_id: int
	
	func _init(p_source_id: int, p_tile_id: Vector2i, p_alternative_tile_id: int):
		source_id = p_source_id
		tile_id = p_tile_id
		alternative_tile_id = p_alternative_tile_id
		
	func _to_string() -> String:
		return "Source: %s, Tile: %s, Alternative: %s" % [source_id, tile_id, alternative_tile_id]
		

func _populate_tile_list() -> void:
	var source_id := TILESET_SOURCE_ID
	var source := tile_set.get_source(source_id)
	
	for i in source.get_tiles_count():
		var tile_id := source.get_tile_id(i)
		var tile := TileLocator.new(source_id, tile_id, 0)
		tile_list.append(tile)
		
func set_seed() -> void:
	if seed:
		var hashed_seed := seed.hash()
		print("Using seed: %s (%d)" % [seed, hashed_seed])
		seed(hashed_seed)
	else:
		print("No seed provided, using random seed.")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_populate_tile_list()
	set_seed()
	clear()
	
	var coords = Vector2i(0, 0)
	for y in 10:
		var tile: TileLocator = tile_list.pick_random()
		print(tile)
		set_cell(coords, tile.source_id, tile.tile_id, tile.alternative_tile_id)
		coords.y = y

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
