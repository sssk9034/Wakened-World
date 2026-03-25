extends CanvasLayer

var _death_scene: PackedScene = preload("res://ui/death/death_scene.tscn")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().root.add_child(_death_scene.instantiate())
	get_tree().create_timer(1.5).timeout.connect(queue_free)
