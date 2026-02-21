extends Node

var player_ref:Player
var _current_level : Node3D


var code_level_res:  = preload("res://scenes/data/CodeLevels.tres")

func _ready() -> void:
	pass

func get_level(code: String)-> PackedScene:
	return code_level_res.code_level_map.get(code)

func set_current_level(current_node : Node):
	_current_level = current_node
	
func load_new_level(new_level : PackedScene):
	if _current_level:
		_current_level.queue_free()
		
	var spawned_level = new_level.instantiate()
	get_tree().root.add_child(spawned_level)
	
	_current_level = spawned_level
	
