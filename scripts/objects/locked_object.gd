extends InteractableObject

func on_interaction(p: Player):
	p.bHasInventoryItem = false
	## TODO: unlock something
	print("interaction completed")

func can_interact(p: Player):
	return p.bHasInventoryItem
