class_name KeepableObject
extends PickableObject



func on_interaction(p: Player):
	print(p.name+" Interacted!")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	get_node("MeshInstance3D/OutLiner").visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func body_entered(body: Node3D) -> void:
	var tv := body as TV
	if not is_instance_valid(tv):
		return
	tv.keepable_object.append(self)

	get_node("MeshInstance3D/OutLiner").visible = true
	
	
func body_exited(body: Node3D) -> void:
	var tv := body as TV
	if not is_instance_valid(tv):
		return
	tv.keepable_object.erase(self)

	get_node("MeshInstance3D/OutLiner").visible = false
	pass
