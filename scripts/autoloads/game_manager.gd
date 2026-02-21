extends Node

var player_ref:Player
var tv_ref:TV
var _current_level : Node3D
var main_ref : Node3D


var code_level_res:  = preload("res://scenes/data/CodeLevels.tres")

func debug_print_levels():
	if not code_level_res:
		print("Resource not loaded!")
		return

	var map = code_level_res.code_level_map
	print("--- Level Dictionary Content (%d items) ---" % map.size())
	
	for code in map:
		var entry = map[code] # This is your LevelEntry
		var scene_path = "NULL"
		var tex_name = "NULL"
		
		if entry:
			if entry.scene: scene_path = entry.scene.resource_path
			if entry.preview_texture: tex_name = entry.preview_texture.resource_name
		
		print("Key: [%s] | Scene: %s | Texture: %s" % [code, scene_path, tex_name])
	
	print("------------------------------------------")

func _ready() -> void:
	debug_print_levels()

func get_level(code: String)-> LevelEntry:
	return code_level_res.code_level_map.get(code)

func set_current_level(current_node : Node):
	_current_level = current_node
	
func load_new_level(new_level : PackedScene):
	tv_ref.reparent(main_ref)
	player_ref.reparent(main_ref)
	player_ref._isOnBoat = false
	
	if _current_level:
		_current_level.queue_free()
		
	var spawned_level = new_level.instantiate()
	get_tree().root.add_child(spawned_level)
	
	_current_level = spawned_level
	
