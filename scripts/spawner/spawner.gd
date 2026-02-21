extends Node3D

var box : BoxShape3D

@onready var whisper = preload("res://assets/Gas_Station_Level/Sound/Whisper.tscn")
var whisper_ini = null
var min_wait : float = 5.0
var max_wait : float = 10.0



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var collision : CollisionShape3D = $Area3D/CollisionShape3D
	box = collision.shape as BoxShape3D
	_spawn()


func _spawn() -> void:
	var size = box.size
	
	var x = randf_range(position.x - size.x, position.x + size.x)
	var z = randf_range(position.z - size.z, position.z + size.z)
	
	var whisper_ini = whisper.instantiate()
	whisper_ini.position =  Vector3(x, GameManager.player_ref.position.y, z)
	add_child(whisper_ini)
	
	await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout
	_spawn()
	
