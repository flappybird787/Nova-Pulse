extends Button
class_name UpgradeCard

var upgrade : UpgradeBase

@export var upgrade_name_label :Label

@export var upgrade_description_label : Label

func _ready() -> void:
	upgrade_name_label.text = "upgrade.upgrade_name"
	upgrade_description_label.text = "upgrade.upgrade_description"
