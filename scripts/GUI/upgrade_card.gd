extends Control
class_name UpgradeCard

var upgrade : UpgradeBase

@export var upgrade_name_label :Label

@export var upgrade_description_label : Label

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if upgrade:
		upgrade_name_label.text = upgrade.upgrade_name
		upgrade_description_label.text = upgrade.upgrade_description


func _on_upgrade_picker_pressed() -> void:
	EventBus.upgrade_chosen.emit(upgrade)
