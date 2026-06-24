extends Node
class_name GUIManagerComponent

@export var health_component : HealthComponent

@export_group("labels")

@export var shield_label : Label

@export var health_label : Label

@export var xp_label : Label

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
	xp_label.text = str(xp_amount,"/", xp_to_next_level, " xp")


func handle_health_labels():
	if health_component.max_shields != 0:
		shield_label.text = str(health_component.shields, "/", health_component.max_shields, " shields")
		
	health_label.text = str(health_component.health, "/", health_component.max_health, " health")

	if is_enemy_gui:
		handle_label_gui_position()


func handle_label_gui_position():
	health_label_pivot.rotation = -get_parent().rotation


func handle_wave_number(wave_number):
	wave_label.text = str("WAVE ", wave_number)
