extends Control


func _on_play_button_pressed() -> void:
	# reset first, then fade into the run
	GameManager.reset_values()
	SceneTransition.change_scene("res://scenes/normal_mode.tscn")
