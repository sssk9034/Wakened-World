@abstract
class_name MapLayout
extends Resource
## Class for building a map using MapTiles.

func _init() -> void:
	# Required since resources are normally not duplicated
	resource_local_to_scene = true


@abstract
func get_next_tile() -> MapTile


@abstract
func has_next_tile() -> bool
