extends Control
class_name UpgradeCard

var upgrade : UpgradeBase

@export var upgrade_name_label :Label

@export var upgrade_description_label : Label

@export var upgrade_texture : TextureRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if upgrade:
		upgrade_name_label.text = upgrade.upgrade_name
		upgrade_description_label.text = upgrade.upgrade_description
		if upgrade.icon != "":
			var image = load(upgrade.icon)
			var texture = image
			#print(texture, " Texture")
			upgrade_texture.texture = texture


func _on_upgrade_picker_pressed() -> void:
	EventBus.upgrade_chosen.emit(upgrade)
