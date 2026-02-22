# Adjust the viewport size of the object outline display
# To prevent the outline from deviating from the object
extends Control

@onready var sub_viewport: SubViewport = $OutlineContainer/SubViewport
@onready var sub_viewport_container: SubViewportContainer = $OutlineContainer


func update_viewport_size() -> void:
	var parent_viewport_size: Vector2 = get_viewport().get_visible_rect().size
	sub_viewport_container.size = parent_viewport_size
	sub_viewport.size = parent_viewport_size


func _ready() -> void:
	update_viewport_size()
	GameManager.on_window_resized.connect(update_viewport_size)
