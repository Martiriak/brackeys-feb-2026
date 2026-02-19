class_name TV
extends InteractableObject


@export var tv_codes: TvCodes = preload("res://levels/tv-hub/tv_codes.tres")


@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen


func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event)


func _on_code_accepted(code: String) -> void:
	print(code)
	# TODO: check if code corresponds to one that can change the scene.
	# USE tv_codes!


func on_interaction(p: Player) -> void:
	print(p.name+" Interacted!")
