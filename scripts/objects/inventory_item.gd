class_name InventoryItem
extends InteractableObject


@export var sfx_pickup_coin : AudioStream  = preload("res://SFX/sfx_pickup_coin.mp3")
@onready var sfx_player = $AudioStreamPlayer3D

@export var item_id : int = 0


func get_string_to_print():
	return '"E" to pick: coin'

func on_interaction(p: Player):
	if not p.inventoryItemsDict.has(item_id):
		p.inventoryItemsDict[item_id] = 0
	p.inventoryItemsDict[item_id] += 1
	
	var temp_audio = AudioStreamPlayer3D.new()
	get_tree().current_scene.add_child(temp_audio)
	
	temp_audio.global_position = self.global_position
	temp_audio.stream = sfx_pickup_coin
	temp_audio.max_distance = 15.0
	temp_audio.bus = "Master"
	temp_audio.play()
	temp_audio.finished.connect(temp_audio.queue_free)
	queue_free()
