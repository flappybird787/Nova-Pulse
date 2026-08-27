extends Node

@export var player_xp : int

# idfk man i wrote this while i was all half asleep
# so if this code is shit thats why
@export var player_level : int = 1

@export var potential_levels = 0

## last weapon the player had equipped, checked when the boss dies to decide which badge to unlock
@export var last_weapon_used : String = "Bullet"

func _ready() -> void:
	EventBus.player_died.connect(reset_values)
	EventBus.boss_killed.connect(display_win_screen)


var started = false
func _process(delta: float) -> void:
	if !started:
		EventBus.xp_changed.emit(player_xp, PlayerUpgradeManager.xp_to_next_level)
		started = true

func reset_values():
	player_level = 1
	player_xp = 0
	PlayerUpgradeManager.current_upgrades = []
	PlayerUpgradeManager.reset()
	potential_levels = 0
	print("RESET EVERYTHING 1")


func display_win_screen():
	# fade into the win screen instead of cutting instantly
	SceneTransition.change_scene("res://scenes/win_screen.tscn")
