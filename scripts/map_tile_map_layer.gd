extends TileMapLayer

const TILESET_SOURCE_IDS: Array[int] = [2]
var rng = RandomNumberGenerator.new()
var tile_list: Array[MapTile] = []
var tile_list_probabilitys: PackedFloat32Array = []

@export var map_seed: String = ""


class MapTile:
	var _tileset: TileSet
	var _source_id: int
	var _atlas_coords: Vector2i
	var _alternative_tile: int
	
	func _init(tileset: TileSet, source_id: int, atlas_coords: Vector2i, alternative_tile: int):
		_tileset = tileset
		_source_id = source_id
		_atlas_coords = atlas_coords
		_alternative_tile = alternative_tile
		
	func _to_string() -> String:
		return "Source: %s, Tile: %s, Alternative: %s" % [_source_id, _atlas_coords, _alternative_tile]
		
	func get_tileset_source() -> TileSetAtlasSource:
		return _tileset.get_source(_source_id)
	
	func get_tile_data() -> TileData:
		return get_tileset_source().get_tile_data(_atlas_coords, _alternative_tile)
		
	func get_custom_property(name: String) -> Variant:
		if not get_tile_data().has_custom_data(name):
			printerr("Tile %s missing custom data property %s" % [self, name])
			return null
		
		return get_tile_data().get_custom_data(name)
		
	func get_start_offset() -> int:
		return get_custom_property("start_offset")
		
	func get_end_offset() -> int:
		return get_custom_property("end_offset")
		
	func get_probability() -> float:
		return get_tile_data().probability
		
	# Takes in the TileMapLayer and TileMap coords to begin placing the tile.
	# Returns the TileMap coords for the next tile.
	func place_tile(tilemap: TileMapLayer, coords: Vector2i) -> Vector2i:
		var place_offset := coords + Vector2i(get_start_offset(), 0)
		var next_offset := place_offset + Vector2i(
			get_end_offset(),
			get_tileset_source().get_tile_size_in_atlas(_atlas_coords).y)
		
		tilemap.set_cell(place_offset, _source_id, _atlas_coords, _alternative_tile)
		
		return next_offset
		
		
func _update_map_seed() -> void:
	if map_seed:
		var hashed_seed := map_seed.hash()
		print("Using seed: %s (%d)" % [map_seed, hashed_seed])
		rng.seed = hashed_seed
	else:
		print("No seed provided, using random seed.")
		rng.randomize()


func _populate_tile_list() -> void:
	# Auto populate standard tilesets
	for source_id in TILESET_SOURCE_IDS:
		if not tile_set.get_source(source_id) is TileSetAtlasSource:
			printerr("TileSet Source ID %s in TILESET_SOURCE_IDS is not of type TileSetAtlasSource." % [source_id])
			continue
			
		var source: TileSetAtlasSource = tile_set.get_source(source_id)
	
		for tile_index in source.get_tiles_count():
			var atlas_coords := source.get_tile_id(tile_index)
			_append_to_tile_list(MapTile.new(tile_set, source_id, atlas_coords, 0))
			
			for alternative_index in source.get_alternative_tiles_count(atlas_coords):
				var alternative_tile = source.get_alternative_tile_id(atlas_coords, alternative_index)
				_append_to_tile_list(MapTile.new(tile_set, source_id, atlas_coords, alternative_tile))
		
	# Populate special tiles
	# TODO
	
	
func _append_to_tile_list(tile: MapTile) -> void:
	tile_list.append(tile)
	tile_list_probabilitys.append(tile.get_probability())
	
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update_map_seed()
	_populate_tile_list()
	clear()
	
	var coords = Vector2i(0, 0)
	for y in 10:
		var tile: MapTile = tile_list[rng.rand_weighted(tile_list_probabilitys)]
		print(tile)
		coords = tile.place_tile(self, coords)


func _physics_process(_delta: float) -> void:
	pass
