class_name TV
extends InteractableObject


@onready var sub_viewport: SubViewport = $Sprite3D/SubViewport
@onready var tv_screen: TvScreen = $Sprite3D/SubViewport/TvScreen

var keepable_object = []

func _unhandled_input(event: InputEvent) -> void:
	sub_viewport.push_input(event)


func _on_code_accepted(code: String) -> void:
	print(code)
	# TODO: check if code corresponds to one that can change the scene.

func on_interaction(p: Player):
	print(p.name+" Interacted!")
