extends Node
class_name AttackTriggerComponent

@export var attack_scene : PackedScene = load("res://prefabs/bullet.tscn")

@export var position : Marker2D

@export var physics_body : CharacterBody2D

## set this to ENEMY for fired from an enemy or PLAYER for fired from the player
@export var attack_team : String

@export var damage_multiplier : int = 1

@export var spread = 0

func _ready() -> void:
	if attack_team == "PLAYER":
		EventBus.upgrade_chosen.connect(apply_upgrades)


func trigger_attack():
	position.rotation_degrees = randi_range(-spread, spread)
	EventBus.fire_attack.emit(position.global_transform, physics_body.velocity, attack_scene, attack_team, damage_multiplier)


func apply_upgrades(upgrade : UpgradeBase):
	if upgrade.upgrade_type == "WEAPON":
		spread = upgrade.spread
		print("spread: ", spread)
	
	if upgrade.upgrade_name == "Damage Booster":
		damage_multiplier += 1
	
	if upgrade.upgrade_name == "Turbolaser":
		attack_scene = load("res://prefabs/turbolaser.tscn")
	
	if upgrade.upgrade_name == "Railgun":
		attack_scene = load("res://prefabs/railgun.tscn")
	
	if upgrade.upgrade_name == "Missile":
		attack_scene = load("res://prefabs/missile.tscn")
