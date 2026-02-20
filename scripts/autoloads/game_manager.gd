extends Node

var player_ref:Player

var code_level_res:  = preload("res://scenes/data/CodeLevels.tres")

func _ready() -> void:
	pass

func get_level(code: String)-> PackedScene:
	return code_level_res.code_level_map.get(code)
