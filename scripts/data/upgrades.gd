extends Node

var all_upgrade_data = [
	{"type": "HEALTH", "name": "Hull Booster", "description": "increases your max health by 20%", "icon" : "res://assets/upgrades/hull_booster.svg", "spread": 0},
	{"type": "HEALTH", "name": "Hull Regen Booster", "description": "increases your health regeneration by 30%", "icon" : "res://assets/upgrades/hull_regen_booster.svg", "spread": 0},
	{"type": "SHIELD", "name": "Shield Booster", "description": "increases your max shields by 20%", "icon" : "res://assets/upgrades/shield_booster.svg", "spread": 0},
	{"type": "SHIELD", "name": "Shield Regen Booster", "description": "increases your sheild regeneration by 30%", "icon" : "res://assets/upgrades/shield_regen_booster.svg", "spread": 0},
	{"type": "DAMAGE", "name": "Damage Booster", "description": "increases your weapon damage by 35%", "icon" : "res://assets/upgrades/damage_booster.svg", "spread": 0},
	{"type": "SHIP", "name": "Speed Booster", "description": "boosts your speed by 20%", "icon" : "res://assets/upgrades/speed_booster.svg", "spread": 0},
	{"type": "DAMAGE", "name": "Fire Rate Booster", "description": "increases your weapon's firerate by 30%", "icon" : "res://assets/upgrades/firerate_booster.svg", "spread": 0},
	{"type": "WEAPON", "name": "Missile", "description": "makes your main weapon be a salvo of missiles as your main weapon, which are relatively slow but capable of tracking targets", "icon" : "res://assets/upgrades/missile.svg", "spread": 30},
	{"type": "WEAPON", "name": "Railgun", "description": "makes your main weapon be a high velocity railgun. this upgrade has high penetration, able to damage multiple enemies doing massive amounts of damage as it does.", "icon" : "res://assets/upgrades/railgun.svg", "spread": 0},
	{"type": "WEAPON", "name": "Turbolaser", "description": "makes your main weapon be a pair of powerfull, fast firing laser bolts.", "icon" : "res://assets/upgrades/turbolaser.svg", "spread": 0},
]

@export var all_upgrades : Array[UpgradeBase] = []


func _ready() -> void:
	for data in all_upgrade_data:
		var upgrade = UpgradeBase.new()
		upgrade.upgrade_name = data.name
		upgrade.upgrade_description = data.description
		upgrade.spread = data.spread
		upgrade.upgrade_type = data.type
		
		upgrade.icon = data.icon
		all_upgrades.append(upgrade)
	
	print(all_upgrades)
