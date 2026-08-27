extends Node

## unlock state per weapon, keyed by the same names used in UpgradeBase.upgrade_name
## NOTE: intentionally in-memory only, not saved to disk - resets every session,
## which is fine for a web build (no user:// persistence to worry about)
var unlocked_weapons := {
	"Missile": false,
	"Railgun": false,
	"Turbolaser": false
}

func _ready() -> void:
	# only unlock on an actual win, not just picking the weapon up
	EventBus.boss_killed.connect(_on_boss_killed)


func _on_boss_killed() -> void:
	# whatever weapon was equipped when the boss died is the one that gets credit
	var weapon = GameManager.last_weapon_used
	if unlocked_weapons.has(weapon):
		unlock_weapon(weapon)


func unlock_weapon(weapon_name : String) -> void:
	unlocked_weapons[weapon_name] = true


func is_unlocked(weapon_name : String) -> bool:
	return unlocked_weapons.get(weapon_name, false)
