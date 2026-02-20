class_name InventoryItem
extends InteractableObject



func on_interaction(p: Player):
	p.bHasInventoryItem = true
	## TODO: play sfx? 
	queue_free()
