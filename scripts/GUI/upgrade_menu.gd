extends Control
class_name UpgradeMenu

@export var upgrade_card_scene : PackedScene

@export var available_upgrades : Array[UpgradeBase]

@export var card_container : HBoxContainer

func _ready() -> void:
	hide()
	EventBus.leveled_up.connect(display_upgrades)


func display_upgrades(level : int):
	for card in card_container.get_children():
		card.queue_free()
	
	get_tree().paused = true
	EventBus.game_paused.emit(true)
	show()
	
	var upgrade_choices = get_random_upgrades(3)


func get_random_upgrades(amount: int):
	var pool = available_upgrades.duplicate()
	pool.shuffle()
	return pool.slice(0, amount)
