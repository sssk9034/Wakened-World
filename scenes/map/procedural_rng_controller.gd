class_name ProceduralRNGController
extends Node

@export var procedural_rng: ProceduralRNG

func _exit_tree() -> void:
	print("[ProceduralRNGController]: Resetting RNG...")
	procedural_rng.reset()
