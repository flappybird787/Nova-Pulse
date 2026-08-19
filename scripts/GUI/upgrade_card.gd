extends Control
class_name UpgradeCard

var upgrade : UpgradeBase

@export var upgrade_name_label :Label

@export var upgrade_description_label : Label

@export var upgrade_texture : TextureRect

var _hover_tween: Tween

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
	# quick confirm chime, no fade so it feels snappy on click
	AudioStreamManager.play("res://assets/audio/upgrade_selected.mp3", 0.0, -5)
	EventBus.upgrade_chosen.emit(upgrade)



## plays a pop-in animation, called by the upgrade menu right after this
## card's upgrade data is set. delay staggers multiple cards so they don't
## all snap in at once
func play_intro(delay: float = 0.0) -> void:
	modulate.a = 0.0
	scale = Vector2(0.7, 0.7)
	pivot_offset = size / 2

	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS) # keep animating while the tree is paused
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, 0.25).set_delay(delay)
	tween.tween_property(self, "scale", Vector2.ONE, 0.3).set_delay(delay).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _on_mouse_entered() -> void:
	if _hover_tween:
		_hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_hover_tween.tween_property(self, "scale", Vector2.ONE * 1.05, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_mouse_exited() -> void:
	if _hover_tween:
		_hover_tween.kill()
	_hover_tween = create_tween()
	_hover_tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	_hover_tween.tween_property(self, "scale", Vector2.ONE, 0.15).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
