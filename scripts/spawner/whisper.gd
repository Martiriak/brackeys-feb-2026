extends Node3D


var is_dead : bool = false



@export var wisphering_constant : AudioStream  = preload("res://SFX/sfx_whispering.wav")
@export var wishpering_gasp : AudioStream  = preload("res://SFX/sfx_whispering_gasp.wav")
@onready var whisper_player = $whisper_player

func _ready() -> void:
	whisper_player.stream = wisphering_constant
	whisper_player.play()
	pass
	


func _on_area_3d_body_entered(body: Node3D) -> void:
	if not is_dead:
		is_dead = true
		whisper_player.stop()
		var temp_audio = AudioStreamPlayer3D.new()
		get_tree().current_scene.add_child(temp_audio)
		temp_audio.global_position = self.global_position
		temp_audio.stream = wishpering_gasp
		temp_audio.max_distance = 15.0
		temp_audio.bus = "Master"
		temp_audio.play()
		temp_audio.finished.connect(temp_audio.queue_free)
		queue_free()
