extends Node
class_name GUIManagerComponent

@export var health_component : HealthComponent

@export_group("labels")

@export var shield_bar : ProgressBar

@export var health_bar : ProgressBar

@export var xp_bar : ProgressBar

@export var health_label_pivot : Control

@export var player_labels : Control

@export var wave_label : Label

## handles the transform of a label, such as a health bar floating above an enemy
@export var is_enemy_gui = false

var showing : bool = true

func _ready() -> void:
	EventBus.xp_changed.connect(handle_xp_labels)
	EventBus.game_paused.connect(handle_labels_visibility)
	EventBus.wave_started.connect(handle_wave_number)


func _process(delta: float) -> void:
	handle_health_labels()
	handle_xp_labels(GameManager.player_xp, PlayerUpgradeManager.xp_to_next_level)


func handle_labels_visibility(paused : bool):
	if !paused:
		player_labels.show()
	
	if paused:
		player_labels.hide()


func handle_xp_labels(xp_amount, xp_to_next_level):
	xp_bar.value = lerp(xp_bar.value, float(xp_amount), 0.1)
	xp_bar.max_value = xp_to_next_level


func handle_health_labels():
	if health_component.max_shields != 0:
		shield_bar.value = lerp(shield_bar.value, float(health_component.shields), 0.1)
		shield_bar.max_value = health_component.max_shields

	if health_component.max_health != 0:
		health_bar.value = lerp(health_bar.value, float(health_component.health), 0.1)
		health_bar.max_value = health_component.max_health

	if is_enemy_gui:
		handle_label_gui_position()


func handle_label_gui_position():
	health_label_pivot.rotation = -get_parent().rotation


func handle_wave_number(wave_number):
	wave_label.text = str("WAVE ", wave_number)
