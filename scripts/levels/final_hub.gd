extends Node3D


func on_level_load():
	GameManager.player_ref.transform = $PlayerSocket.transform
	GameManager.tv_ref.transform = $TVSocket.transform
	
func on_level_unload():
	pass
