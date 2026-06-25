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
		print(upgrade.icon)
		if upgrade.icon != "":
			var image = Image.load_from_file(upgrade.icon)
			var texture = ImageTexture.create_from_image(image)
			print(texture, " Texture")
			upgrade_texture.texture = texture


func _on_upgrade_picker_pressed() -> void:
	EventBus.upgrade_chosen.emit(upgrade)
