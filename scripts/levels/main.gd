extends Node3D

@onready var hub_node: Node3D = $FinalHub

func _ready():
	GameManager.set_current_level(hub_node)
	GameManager.main_ref = self
	
