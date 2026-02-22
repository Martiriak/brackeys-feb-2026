extends CollisionShape3D



func _on_area_3d_body_entered(body):
	# Check if the thing entering is actually the player
	if body == GameManager.player_ref:

		# Optional: Disable the area so it doesn't trigger twice
		$Area3D/CollisionShape3D.set_deferred("disabled", true)
