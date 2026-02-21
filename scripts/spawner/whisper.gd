extends Node
@onready var sfx_whisper_player = $sfx_whisper
@export var sfx_gasp: AudioStream  = preload("res://SFX/sfx_whispering_gasp.wav")


func on_enter(body: Node3D) -> void:
	print("pisello")
	var player = body as Player
	if is_instance_valid(player):
		sfx_whisper_player.stop()
		sfx_whisper_player.stream = sfx_gasp
		sfx_whisper_player.play()
	pass
