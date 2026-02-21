class_name LockedObject
extends InteractableObject

@export var requested_id : int = 0
@export var requested_items_to_unlock = 1


@onready var falling_can_animation_player: AnimationPlayer = $VendingMachine/FallingCanAnimationPlayer
@onready var animation_player: AnimationPlayer = $VendingMachine/AnimationPlayer

@onready var can_object := $VendingMachine/CanObject as SodaCan

func on_level_unload():
	can_object.can_camera.current = false

var bLocked : bool = true

func on_interaction(p: Player):
	if p.inventoryItemsDict.has(requested_id):
		if p.inventoryItemsDict[requested_id] >= requested_items_to_unlock:
			p.inventoryItemsDict[requested_id] -= requested_items_to_unlock
			if p.inventoryItemsDict[requested_id] < 0:
				p.inventoryItemsDict[requested_id] = 0
			bLocked = false
			falling_can_animation_player.play("FallingCan")
			print("interaction completed")
			## TODO: unlock something

func can_interact(p: Player):
	return bLocked and p.inventoryItemsDict.has(requested_id) and p.inventoryItemsDict[requested_id] >= requested_items_to_unlock


func play_open_animation():
	animation_player.play("Vending Machine_002Action")
