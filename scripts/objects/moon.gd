class_name Moon
extends InteractableObject

@export var requested_id : int = 0
@export var requested_items_to_unlock = 2
@export var requested_items_to_half = 1


@onready var moon_position_1: Marker3D = $"../MoonPosition1"
@onready var moon_position_2: Marker3D = $"../MoonPosition2"


var bLocked : bool = true

func _process(delta: float) -> void:
	if GameManager.player_ref.inventoryItemsDict.has(requested_id):
		var counter = GameManager.player_ref.inventoryItemsDict.get(requested_id)
		if counter >= requested_items_to_unlock:
			position = moon_position_2.position
		elif counter >= requested_items_to_half:
			position = moon_position_1.position


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
