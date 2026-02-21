extends Node3D

@onready var hub_node: Node3D = $FinalHub

<<<<<<< HEAD

func _ready() -> void:
	GameManager.set_main_hub_level(hub_node)
	GameManager.main_ref = self
