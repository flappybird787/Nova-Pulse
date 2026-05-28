extends Node
class_name GUIManagerComponent

@export var health_component : HealthComponent

@export_group("labels")

@export var shield_label : Label

@export var health_label : Label

@export var xp_label : Label

@export var health_label_pivot : Control

## handles the transform of a label, such as a health bar floating above an enemy
@export var is_enemy_gui = false

func _process(delta: float) -> void:
	handle_health_labels()
	handle_xp_labels()


func handle_xp_labels():
	xp_label.text = str(GameManager.player_xp, " xp")


func handle_health_labels():
	if health_component.max_shields != 0:
		shield_label.text = str(health_component.shields, "/", health_component.max_shields, " shields")
		
	health_label.text = str(health_component.health, "/", health_component.max_health, " health")

	if is_enemy_gui:
		handle_label_gui_position()


func handle_label_gui_position():
	health_label_pivot.rotation = -get_parent().rotation
