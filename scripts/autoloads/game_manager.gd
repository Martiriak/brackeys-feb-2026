extends Node

var player_ref:Player
var tv_ref:TV
var _current_level : Node3D


var code_level_res:  = preload("res://scenes/data/CodeLevels.tres")

var instantiated_levels : Dictionary[PackedScene, Node3D] = {}

func _ready() -> void:
	# Pre-instantiate all levels in the background at start
	pre_instantiate_all_levels()

func pre_instantiate_all_levels():
	for code in code_level_res.code_level_map:
		var entry = code_level_res.code_level_map[code]
		if entry.scene.resource_path.contains("final_hub.tscn"):
			continue
		if entry and entry.scene:
			_create_and_hide_level(entry.scene)

func _create_and_hide_level(scene: PackedScene) -> Node3D:
	if not instantiated_levels.has(scene):
		var spawned = scene.instantiate()
		# Add them to the root but keep them hidden and disabled
		get_tree().root.add_child.call_deferred(spawned)
		spawned.hide()
		spawned.process_mode = Node.PROCESS_MODE_DISABLED
		instantiated_levels[scene] = spawned
		return spawned
	return instantiated_levels[scene]

func load_new_level(new_level: PackedScene):
	if _current_level:
		_current_level.process_mode = Node.PROCESS_MODE_DISABLED
		_current_level.hide()
	
	# Because we pre-instantiated, it should almost always be in the dictionary
	var level_to_show = _create_and_hide_level(new_level)
	
	level_to_show.show()
	level_to_show.process_mode = Node.PROCESS_MODE_INHERIT
	_current_level = level_to_show

func get_level(code: String) -> LevelEntry:
	return code_level_res.code_level_map.get(code)
	
func set_main_hub_level(main_hub_node : Node3D):
	for code in code_level_res.code_level_map:
		var entry = code_level_res.code_level_map[code]
		if entry.scene.resource_path.contains("final_hub.tscn"):
			instantiated_levels[entry.scene] = main_hub_node
	_current_level = main_hub_node
	
	
