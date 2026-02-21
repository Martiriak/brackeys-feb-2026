extends Node3D


func spawn(obj_to_spawn):
	var obj_to_spawn_insta : Node3D =  obj_to_spawn.instantiate()
	add_child(obj_to_spawn_insta)

func on_obj_to_spawn_is_remove() -> void:
	if get_child_count() <= 0:
		get_parent()._spawn_next()
