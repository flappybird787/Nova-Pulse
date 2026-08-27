extends Node
class_name AttackTriggerComponent

@export var attack_scene : PackedScene = load("res://prefabs/weapons/bullet.tscn")

@export var position : Marker2D

@export var physics_body : CharacterBody2D

## set this to ENEMY for fired from an enemy or PLAYER for fired from the player
@export var attack_team : String

@export var damage_multiplier : int = 1

@export var spread = 0

@export var attack_color : Color = Color("50b5ff")

## sound played when the player fires this weapon, changes per weapon type
@export var fire_sound : String = "res://assets/audio/blaster_sound.mp3"

## fire sound paths per weapon, kept together so they're easy to find/change
const BULLET_SOUND = "res://assets/audio/blaster_sound.mp3"
const TURBOLASER_SOUND = "res://assets/audio/blaster_sound.mp3"
const RAILGUN_SOUND = "res://assets/audio/railgun_sound.mp3"
const MISSILE_SOUND = "res://assets/audio/missile_sound.mp3"

func _ready() -> void:
	# explicitly set the default weapon's sound (bullet), same as the starting attack_scene
	fire_sound = BULLET_SOUND
	
	if attack_team == "PLAYER":
		EventBus.upgrade_chosen.connect(apply_upgrades)


func trigger_attack():
	position.rotation_degrees = randi_range(-spread, spread)
	EventBus.fire_attack.emit(position.global_transform, physics_body.velocity, attack_scene, attack_team, damage_multiplier, attack_color)
	
	# only play the blaster sfx for the player's own shots, not enemies
	# 0.0 fade time = play instantly, no fade-in delay
	if attack_team == "PLAYER":
		AudioStreamManager.play(fire_sound, 0.0, -15)


func apply_upgrades(upgrade : UpgradeBase):
	if upgrade.upgrade_type == "WEAPON":
		spread = upgrade.spread
		# track which weapon is equipped so we know what to unlock on a win
		GameManager.last_weapon_used = upgrade.upgrade_name

	if upgrade.upgrade_name == "Damage Booster":
		damage_multiplier += 1.35

	if upgrade.upgrade_name == "Turbolaser":
		attack_scene = load("res://prefabs/weapons/turbolaser.tscn")
		fire_sound = TURBOLASER_SOUND

	if upgrade.upgrade_name == "Railgun":
		attack_scene = load("res://prefabs/weapons/railgun.tscn")
		fire_sound = RAILGUN_SOUND

	if upgrade.upgrade_name == "Missile":
		attack_scene = load("res://prefabs/weapons/missile.tscn")
		fire_sound = MISSILE_SOUND
