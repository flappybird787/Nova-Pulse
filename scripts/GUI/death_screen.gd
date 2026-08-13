extends Control


func _on_restart_button_pressed() -> void:
	GameManager.reset_values()
	SceneTransition.change_scene("res://scenes/normal_mode.tscn")

func _on_main_menu_button_pressed() -> void:
	GameManager.reset_values()
	SceneTransition.change_scene("res://scenes/main_menu.tscn")
