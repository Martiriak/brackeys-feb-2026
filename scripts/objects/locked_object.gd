class_name LockedObject
extends InteractableObject

@export var requested_id : int = 0
@export var requested_items_to_unlock = 1

@onready var animation_player: AnimationPlayer = $VendingMachine/AnimationPlayer
## Same name as animation, can't rename so I get the name from the node itself.
@onready var vending_machine_002: MeshInstance3D = $"VendingMachine/Vending Machine_002"


var bLocked : bool = true

func on_interaction(p: Player):
	if p.inventoryItemsDict.has(requested_id):
		if p.inventoryItemsDict[requested_id] >= requested_items_to_unlock:
			p.inventoryItemsDict[requested_id] -= requested_items_to_unlock
			if p.inventoryItemsDict[requested_id] < 0:
				p.inventoryItemsDict[requested_id] = 0
			bLocked = false
			animation_player.play(animation_player.get_animation_list().get(0))
			print("interaction completed")
			## TODO: unlock something

func can_interact(p: Player):
	return bLocked and p.inventoryItemsDict.has(requested_id) and p.inventoryItemsDict[requested_id] >= requested_items_to_unlock
