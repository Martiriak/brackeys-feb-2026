extends Node3D

var second : float = 2.0

var max_car = 1

var min_wait : float = 5.0
var max_wait : float = 10.0

@onready var car = preload("res://assets/Gas_Station_Level/Sound/CarSpawner.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn()


func _spawn() -> void:
	if get_child_count() >= max_car:
		return
		 
	var car_ini = car.instantiate()
	car_ini.seconds = second
	car_ini.seconds = second
	var raycast : RayCast3D = $SpawnDiretion
	var direction = raycast.position.direction_to(raycast.target_position)
	car_ini.direction =  direction
	
	await get_tree().create_timer(randf_range(min_wait, max_wait)).timeout
	_spawn()
