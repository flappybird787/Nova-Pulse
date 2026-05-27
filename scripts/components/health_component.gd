extends Node
class_name HealthComponent

@export var health : int

@export var max_health : int

@export var shields : int

@export var max_shields : int

@export_group("labels")

@export var shield_label : Label

@export var health_label : Label

@export var health_label_pivot : Control

## handles the transform of a label, such as a health bar floating above an enemy
@export var handle_label_transforms = false


func _process(delta: float) -> void:
	if max_shields != 0:
		shield_label.text = str(shields, "/", max_shields, " shields")
		
	health_label.text = str(health, "/", max_health, " health")

	if handle_label_transforms:
		handle_label_gui()


func deal_damage(amount: int):
	for i in range(amount):
		if max_shields != 0 and shields > 0:
			shields -= 1
		
		else:
			health -= 1


func heal(amount):
	for i in range(amount):
		if max_shields != 0 and shields > 0 and shields < max_shields:
			shields += 1
		
		elif health < max_health:
			health += 1


func handle_label_gui():
	health_label_pivot.rotation = -get_parent().rotation


func _on_healing_timer_timeout() -> void:
	heal(1)
