class_name InventoryItem
extends InteractableObject

@export var item_id : int = 0

func on_interaction(p: Player):
	if not p.inventoryItemsDict.has(item_id):
		p.inventoryItemsDict[item_id] = 0
	p.inventoryItemsDict[item_id] += 1
	## TODO: play sfx?
	queue_free()
