extends Control
class_name UpgradeMenu

@export var upgrade_card_scene : PackedScene

@export var upgrade_icon_scene : PackedScene

@export var available_upgrades : Array

@export var available_level_1_upgrades : Array

@export var card_container : HBoxContainer

@export var icon_container : GridContainer

func _ready() -> void:
	EventBus.leveled_up.connect(display_upgrades)
	EventBus.game_paused.connect(handle_visibility)
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	available_upgrades = Upgrades.all_upgrades
	available_level_1_upgrades = Upgrades.level_1_upgrades


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("reroll_upgrade"):
		display_upgrades(1)


func display_upgrade_icons():
	for icon in icon_container.get_children():
		icon.queue_free()
	
	for upgrade in PlayerUpgradeManager.current_upgrades:
		var i = upgrade_icon_scene.instantiate()
		icon_container.add_child(i)
		i.upgrade = upgrade


func display_upgrades(level : int):
	print("LEVEL: ", level)
	display_upgrade_icons()
	
	for card in card_container.get_children():
		card.queue_free()
	
	get_tree().paused = true
	EventBus.game_paused.emit(true)
	
	var upgrade_choices
	
	# use the weapon-only deck only for the player's very first upgrade pick,
	# checking current_upgrades instead of "level" since player_level can
	# increment multiple times before the player ever opens this menu
	if PlayerUpgradeManager.current_upgrades.is_empty():
		upgrade_choices = get_random_upgrades(3, 1)
	else:
		upgrade_choices = get_random_upgrades(3, 0)
	
	for upgrade in upgrade_choices:
		var c = upgrade_card_scene.instantiate()
		card_container.add_child(c)
		c.upgrade = upgrade


func handle_visibility(paused : bool):
	if paused:
		show()

	if !paused:
		hide()

## deck is the upgrade deck to pull from, 0 for all upgrades and 1 for level 1 upgrades
func get_random_upgrades(amount: int, deck: int):
	if deck == 0:
		var pool = available_upgrades.duplicate()
		pool.shuffle()
		return pool.slice(0, amount)
	
	elif deck == 1:
		var pool = available_level_1_upgrades.duplicate()
		pool.shuffle()
		return pool.slice(0, amount)
