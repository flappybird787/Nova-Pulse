extends Node

@export var xp_to_next_level : int

@export var current_upgrades : Array[UpgradeBase]

func _ready() -> void:
	xp_to_next_level = calculate_xp_needed()
	EventBus.gain_xp.connect(gain_xp)
	EventBus.upgrade_chosen.connect(apply_upgrade)
	EventBus.player_died.connect(reset)
	
	EventBus.xp_changed.emit(GameManager.player_xp, xp_to_next_level)

func reset():
	xp_to_next_level = 0
	GameManager.player_level = 1
	xp_to_next_level = calculate_xp_needed()
	print("RESET EVERYTHING 1")


func level_up():
	GameManager.player_level += 1
	xp_to_next_level = calculate_xp_needed()
	EventBus.leveled_up.emit(GameManager.player_level)
	print("leveled up")


func gain_xp(amount : int):
	GameManager.player_xp += amount
	print(amount)
	
	# While loop handles cases where the player gains enough XP to level up multiple times at once
	while GameManager.player_xp >= xp_to_next_level:
		GameManager.player_xp -= xp_to_next_level
		level_up()
	
	EventBus.xp_changed.emit(GameManager.player_xp, xp_to_next_level)


func calculate_xp_needed():
	return GameManager.player_level * 4


func apply_upgrade(upgrade : UpgradeBase):
	get_tree().paused = false
	EventBus.game_paused.emit(false)
	current_upgrades.append(upgrade)
