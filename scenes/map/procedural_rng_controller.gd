class_name ProceduralRNGController
extends Node

@export var procedural_rng: ProceduralRNG

func _exit_tree() -> void:
	procedural_rng.reset()
