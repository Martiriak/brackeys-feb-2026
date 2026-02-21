class_name MainHub
extends Node3D
@onready var door: Node3D = $Door

func	 delete_door():
	door.queue_free()
