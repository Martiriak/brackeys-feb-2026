class_name Moon
extends InteractableObject

@export var requested_id : int = 0
@export var requested_items_to_unlock = 1

var bLocked : bool = true

func on_interaction(p: Player):
	if p.inventoryItemsDict.has(requested_id):
		if p.inventoryItemsDict[requested_id] >= requested_items_to_unlock:
			p.inventoryItemsDict[requested_id] -= requested_items_to_unlock
			if p.inventoryItemsDict[requested_id] < 0:
				p.inventoryItemsDict[requested_id] = 0
			bLocked = false

func can_interact(p: Player):
	return bLocked and p.inventoryItemsDict.has(requested_id) and p.inventoryItemsDict[requested_id] >= requested_items_to_unlock

func get_string_to_print():
	return '"E" to interact'
