class_name SodaCan
extends Node3D

@export var levelCode : Array[int] = [0, 2, 0, 2, 0]

@onready var sprite_3d: Sprite3D = $Sprite3D
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen

func show_code():
	sprite_3d.show()
	tv_screen.hide_active_slot_indicator()

func _ready() -> void:
	tv_screen.set_code(levelCode)
	show_code()
