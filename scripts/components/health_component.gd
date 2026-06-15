extends Node
class_name HealthComponent

@export var health : int

@export var max_health : int

@export var health_regen : int

@export var shields : int

@export var max_shields : int

@export var shield_regen : int

@export var is_player : bool = false

@export var health_label : Label

func _ready() -> void:
	if is_player:
		EventBus.upgrade_chosen.connect(apply_upgrade)

func _process(delta: float) -> void:
	if !is_player:
		health_label.text = str(health, "/", max_health)

func deal_damage(amount: int):
	for i in range(amount):
		if max_shields != 0 and shields > 0:
			shields -= 1
		
		else:
			health -= 1


func _on_healing_timer_timeout() -> void:
	if max_shields != 0 and health >= max_health and shields < max_shields:
		shields += shield_regen
		if shields > max_shields:
			shields = max_shields
	
	elif health < max_health:
		health += health_regen
		if health > max_health:
			health = max_health


func apply_upgrade(upgrade: UpgradeBase):
	if upgrade.upgrade_name == "Hull Booster":
		max_health += 15
		health += 15
	
	if upgrade.upgrade_name == "Shield Booster":
		max_shields += 15
		shields += 15
	
	if upgrade.upgrade_name == "Hull Regen Booster":
		health_regen += 2
	
	if upgrade.upgrade_name == "Shield Regen Booster":
		shield_regen += 2
