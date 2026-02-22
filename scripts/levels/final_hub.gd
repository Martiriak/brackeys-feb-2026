extends Node3D

@onready var node: MainHub = $Node


func on_level_load():
	GameManager.player_ref.transform = $PlayerSocket.transform
	GameManager.tv_ref.transform = $TVSocket.transform
	if GameManager.game_completed:
		node.delete_door()
	
func on_level_unload():
	pass
