extends InteractableObject


@export var sfx_quack : AudioStream  = preload("res://SFX/DuckQuack.mp3")
@onready var sfx_player = $AudioStreamPlayer3D

@export var item_id : int = 0


func get_string_to_print():
	return '"E" to quack'

func on_interaction(p: Player):
	var temp_audio = AudioStreamPlayer3D.new()
	get_tree().current_scene.add_child(temp_audio)
	
	temp_audio.global_position = self.global_position
	temp_audio.stream = sfx_quack
	temp_audio.max_distance = 15.0
	temp_audio.bus = "Master"
	temp_audio.play()
	temp_audio.finished.connect(temp_audio.queue_free)
	queue_free()
