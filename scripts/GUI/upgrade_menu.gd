extends Control
class_name UpgradeMenu

@export var upgrade_card_scene : PackedScene

@export var available_upgrades : Array[UpgradeBase]

@export var card_container : HBoxContainer

func _ready() -> void:
	EventBus.leveled_up.connect(display_upgrades)
	EventBus.game_paused.connect(handle_visibility)
	hide()


func display_upgrades(level : int):
	for card in card_container.get_children():
		card.queue_free()
	
	get_tree().paused = true
	EventBus.game_paused.emit(true)
	
	var upgrade_choices = get_random_upgrades(3)
	
	for upgrade in upgrade_choices:
		var c = upgrade_card_scene.instantiate()
		card_container.add_child(c)
		c.upgrade = upgrade


func handle_visibility(paused : bool):
	if paused:
		show()

	if !paused:
		hide()

func get_random_upgrades(amount: int):
	var pool = available_upgrades.duplicate()
	pool.shuffle()
	return pool.slice(0, amount)
