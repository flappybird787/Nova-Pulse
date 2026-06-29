extends Control
class_name UpgradeIcon

var upgrade : UpgradeBase

@export var upgrade_texture : TextureRect

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS

func _process(delta: float) -> void:
	if upgrade:
		if upgrade.icon != "":
			var image = load(upgrade.icon)
			var texture = image
			upgrade_texture.texture = texture
