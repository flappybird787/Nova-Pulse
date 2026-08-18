extends Node
class_name HealthComponent

@export var health : int

@export var max_health : int

@export var health_regen : int

@export var shields : int

@export var max_shields : int

@export var shield_regen : int

@export var is_player : bool = false

@export var health_bar : ProgressBar

@export var health_bar_pivot : Control

@export var hit_scale_component : HitScaleComponent

## sound played when this ship (non-player) takes a hit, leave blank to skip
@export var hit_sound_path : String = "res://assets/audio/hit_sound.mp3"

func _ready() -> void:
	if is_player:
		EventBus.upgrade_chosen.connect(apply_upgrade)

func _process(delta: float) -> void:
	if !is_player:
		health_bar.max_value = max_health
		health_bar.value = health
		
		handle_healthbar_rotation()


func handle_healthbar_rotation():
	if !is_player:
		#print("health bar rotation: ", health_bar_pivot.rotation_degrees)
		pass


func deal_damage(amount: int):
	for i in range(amount):
		if max_shields != 0 and shields > 0:
			shields -= 1
		
		else:
			health -= 1
	
	hit_scale_component.trigger_scale_effect()
	
	if is_player:
		EventBus.player_hit.emit()
	else:
		# enemy took a hit from the player, not necessarily a kill
		if hit_sound_path != "":
			AudioStreamManager.play(hit_sound_path, 0.0) # 0.0 fade so it's snappy, not a slow fade-in


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
		max_health *= 1.2
		health *= 1.2
	
	if upgrade.upgrade_name == "Shield Booster":
		max_shields *= 1.2
		shields *= 1.2
	
	if upgrade.upgrade_name == "Hull Regen Booster":
		health_regen *= 1.3
	
	if upgrade.upgrade_name == "Shield Regen Booster":
		shield_regen *= 1.3
