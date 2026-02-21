extends Node3D

func _ready() -> void:
	GameManager.player_ref.reparent(self)
	#$PlayerSocket.replace_by(GameManager.player_ref)
	
	pass
