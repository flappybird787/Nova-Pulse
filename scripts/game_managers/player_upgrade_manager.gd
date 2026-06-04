extends Node

@export var xp_to_next_level : int

func _ready() -> void:
	xp_to_next_level = calculate_xp_needed()
	EventBus.gain_xp.connect(gain_xp)
	
	EventBus.xp_changed.emit(GameManager.player_xp, xp_to_next_level)

func _process(delta: float) -> void:
	pass


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
	
