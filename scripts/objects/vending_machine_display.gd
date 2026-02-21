class_name VendingMachineDisplay
extends Node3D
@onready var label_3d: Label3D = $Label3D

var counter_id : int = 0
var max_objects : int = 0

func _ready() -> void:
	if get_parent() is LockedObject:
		var interactable_object = get_parent() as LockedObject
		counter_id = interactable_object.requested_id
		max_objects = interactable_object.requested_items_to_unlock

func _process(delta: float) -> void:
	var current : int = 0
	if GameManager.player_ref and GameManager.player_ref.inventoryItemsDict.has(counter_id):
		current = GameManager.player_ref.inventoryItemsDict.get(counter_id)
	label_3d.text = "%d/%d" % [current, max_objects]
	
