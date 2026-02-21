extends Node3D
class_name GasStation

@onready var gas_station_pump := $Gas_Station_pump as Node3D
var player : Player
var tv : TV

func on_level_load() -> void:
	player = GameManager.player_ref
	player.transform = $PlayerSocket.transform	
	
	tv = GameManager.tv_ref
	tv.transform = $TVSocket.transform
