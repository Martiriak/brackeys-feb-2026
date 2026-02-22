@tool
extends Node3D


@export_tool_button("Add fix spawn")
var add_spawn_button = _add_spawn

@export_tool_button("Remove last fix spawn")
var remove_spawn_button = _remove_spawn 

@export_tool_button("Clear childs")
var clear_childs_button = _clear_childs


@export var cycle_after_end : bool = false
@export var coin_to_spawn = "res://scenes/objects/coin.tscn"


@export var obj_to_spawn = "res://assets/Gas_Station_Level/Sound/Whisper.tscn"
@onready var fix_spawn = preload("res://assets/Gas_Station_Level/Sound/FixSpawn.tscn")
@onready  var obj_to_spawn_loaded = load(obj_to_spawn)


var fix_spawns: Array[Node3D] = []
var current_fix_spawn = 0



func _add_spawn() -> void:
	
	#var undo_redo = EditorInterface.get_editor_undo_redo()
	
	var fix_spawn_insta : Node3D =  fix_spawn.instantiate()
	fix_spawn_insta.name = "FixSpawn_" + str(fix_spawns.size())
	fix_spawns.append(fix_spawn_insta)
	add_child(fix_spawn_insta)
	fix_spawn_insta.set_owner(get_tree().get_edited_scene_root())
	
func _remove_spawn() -> void:
	var last : int = fix_spawns.size() - 1
	fix_spawns[last].queue_free()
	fix_spawns.remove_at(last)

func _clear_childs() -> void:
	get_children(true).all(delete)
	fix_spawns.clear()	
	
func delete(element : Node3D):
	element.queue_free()
	return true
	
func _on_childs_change():
	if fix_spawns.is_empty():
		return
	var current : int = 0
	for child : Node3D in get_children():
		var number : int = int(child.name.replace("FixSpawn_", ""))
		if number != current:
			fix_spawns.remove_at(current)
			for i in range(current, fix_spawns.size()):
				fix_spawns[i].name = "FixSpawn_" + str(i)
		current += 1
	print(fix_spawns)

func _ready() -> void:
	for child in get_children():
		fix_spawns.append(child)
	_spawn_next()

func _spawn_next() -> void:
	if fix_spawns.is_empty():
		push_warning("Nessun punto di spawn trovato in fix_spawns!")
		return
	if current_fix_spawn >= fix_spawns.size():
		print("Fine del percorso raggiunta. Lo spawner si ferma.")
		_on_spawner_finished()
		return
	_spawn_object()
	current_fix_spawn += 1

func _on_spawner_finished() -> void:
	#if coin_to_spawn:
		#var final_obj = coin_to_spawn.instantiate()
		#get_parent().add_child(final_obj)
		## Opzionale: posizionalo sull'ultimo punto di spawn invece che sullo spawner
		#final_obj.global_position = fix_spawns.back().global_position
	pass


func _spawn_object() -> void:
	fix_spawns[current_fix_spawn].spawn(obj_to_spawn_loaded)
