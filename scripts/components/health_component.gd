extends Node
class_name HealthComponent

@export var health : int

@export var max_health : int

@export var shields : int

@export var max_shields : int

@export var is_player : bool = false


func _ready() -> void:
	EventBus.upgrade_chosen.connect(apply_upgrade)


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


func _on_healing_timer_timeout() -> void:
	heal(1)


func apply_upgrade(upgrade: UpgradeBase):
	if upgrade.upgrade_name == "Hull Booster":
		max_health += 15
		health += 15
	
	if upgrade.upgrade_name == "Shield Booster":
		max_shields += 15
		shields += 15
