extends Control


func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/normal_mode.tscn")
	GameManager.reset_values()

func _on_main_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")
	GameManager.reset_values()
