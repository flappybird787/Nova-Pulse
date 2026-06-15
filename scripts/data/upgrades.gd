extends Node

var all_upgrade_data = [
	{"type": "HEALTH", "name": "Hull Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "HEALTH", "name": "Hull Regen Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "SHIELD", "name": "Shield Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "SHIELD", "name": "Shield Regen Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "DAMAGE", "name": "Damage Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "SHIP", "name": "Speed Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "DAMAGE", "name": "Fire Rate Booster", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "WEAPON", "name": "Missile", "description": "DONT USE THIS IN THE BOSS BATTLE IT WONT TRACK THE BOSS IDK WHY BUT I DONT WANNA FIX IT ITS 3AM IM 6 AND A HALF ENERGY DRINKS IN AND I CAN TASTE COLORS", "icon" : Image, "art": Image, "spread": 30},
	{"type": "WEAPON", "name": "Railgun", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
	{"type": "WEAPON", "name": "Turbolaser", "description": "lore.txt", "icon" : Image, "art": Image, "spread": 0},
]

@export var all_upgrades : Array[UpgradeBase] = []


func _ready() -> void:
	for data in all_upgrade_data:
		var upgrade = UpgradeBase.new()
		upgrade.upgrade_name = data.name
		upgrade.upgrade_description = data.description
		upgrade.spread = data.spread
		upgrade.upgrade_type = data.type
		#upgrade.icon = data.icon
		#upgrade.art = data.art
		all_upgrades.append(upgrade)
	
	print(all_upgrades)
