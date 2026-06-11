extends Node
class_name ShipDataComponent

## the speed that the ship moves forward
@export var ship_speed = 0.0

## the health of the ship hull
@export var ship_health = 0

## the health of the ship's shields
@export var ship_shield_health = 0

## how fast the ship turns
@export var ship_agility = 0

## how fast the ship accelerates forwards
@export var ship_acceleration = 0

@export var is_player = false


func _ready() -> void:
	if is_player:
		EventBus.upgrade_chosen.connect(apply_upgrades)


func apply_upgrades(upgrade : UpgradeBase):
	if upgrade.upgrade_name == "Speed Booster":
		ship_speed *= 1.2
		ship_acceleration += 5
