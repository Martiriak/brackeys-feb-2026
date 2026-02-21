extends Node3D

@onready var gas_station_pump := $Gas_Station_pump as Node3D
var player : Player
var tv : TV

func _ready() -> void:
	player = GameManager.player_ref
	player.reparent(self)
	player.transform = $PlayerSocket.transform
	
	tv = GameManager.tv_ref
	tv.reparent(self)
	tv.transform = $TVSocket.transform
