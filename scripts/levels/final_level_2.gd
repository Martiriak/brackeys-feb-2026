extends Node3D

@onready var _boat_scene := $BoatScene as Node3D

func on_level_load():
	if _boat_scene:
		for child in _boat_scene.get_children():
			var boat : Boat = child as Boat
			if boat:
				boat.on_level_load()
				return

func on_level_unload():
	GameManager.tv_ref.reparent(GameManager.main_ref)
	GameManager.player_ref.reparent(GameManager.main_ref)
	GameManager.player_ref._isOnBoat = false
