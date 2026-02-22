extends Window

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_SIZE_CHANGED:
		GameManager.on_window_resized.emit()
