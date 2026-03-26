class_name ProceduralRNGController
extends Node

@export var procedural_rng: ProceduralRNG

@export var rng_seed: String:
	set(value):
		rng_seed = value
		procedural_rng.rng_seed = value
