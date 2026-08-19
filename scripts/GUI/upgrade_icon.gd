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


## pop-in animation, called right after this icon's upgrade is assigned.
## delay staggers multiple icons so they ripple in instead of snapping at once
func play_intro(delay: float = 0.0) -> void:
	modulate.a = 0.0
	scale = Vector2(0.7, 0.7)
	pivot_offset = size / 2

	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)  # menu pauses the tree right after this
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.2).set_delay(delay)
	tween.tween_property(self, "scale", Vector2.ONE, 0.25).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
