extends Node

var all_upgrade_data = [
	{"type": "HEALTH", "name": "Hull Booster", "description": "This upgrade uses reinforced alloys to boost the strength of the hull", "icon" : Image, "art": Image},
	{"type": "HEALTH", "name": "Hull Regen Booster", "description": "This upgrade uses nanobots to boost the regeneration of the hull", "icon" : Image, "art": Image},
	{"type": "SHIELD", "name": "Shield Booster", "description": "This upgrade uses better capacitors to boost the strength of the shield", "icon" : Image, "art": Image},
	{"type": "SHIELD", "name": "Shield Regen Booster", "description": "lore.txt", "icon" : Image, "art": Image},
	{"type": "DAMAGE", "name": "Damage Booster", "description": "lore.txt", "icon" : Image, "art": Image},
	{"type": "SHIP", "name": "Speed Booster", "description": "lore.txt", "icon" : Image, "art": Image},
	{"type": "DAMAGE", "name": "Fire Rate Booster", "description": "lore.txt", "icon" : Image, "art": Image},
	{"type": "WEAPON", "name": "Missile Launcher", "description": "lore.txt", "icon" : Image, "art": Image},
	{"type": "WEAPON", "name": "Railgun", "description": "lore.txt", "icon" : Image, "art": Image},
	{"type": "WEAPON", "name": "Turbolaser", "description": "lore.txt", "icon" : Image, "art": Image},
	
]

@export var all_upgrades : Array[UpgradeBase] = []


func _ready() -> void:
	for data in all_upgrade_data:
		var upgrade = UpgradeBase.new()
		upgrade.upgrade_name = data.name
		upgrade.upgrade_description = data.description
		#upgrade.icon = data.icon
		#upgrade.art = data.art
		all_upgrades.append(upgrade)
	
	print(all_upgrades)
