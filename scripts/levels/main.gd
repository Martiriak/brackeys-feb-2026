extends Node3D

@onready var hub_node: Node3D = $FinalHub

@onready var world_environment: WorldEnvironment = $WorldEnvironment

func _ready() -> void:
	GameManager.set_main_hub_level(hub_node)
	GameManager.main_ref = self
	GameManager.world_environment = world_environment
