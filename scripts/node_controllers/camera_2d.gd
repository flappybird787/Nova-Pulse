extends Camera2D

var shake_strength := 0.0
var shake_decay := 5.0  # how fast the shake fades
var shake_max_offset := 16.0  # max pixels of shake

## how much the camera zooms in for the level-up punch (0.08 = 8% zoom)
@export var level_up_punch_zoom := 0.08
@export var level_up_punch_duration := 0.3

var base_zoom : Vector2

func _ready() -> void:
	EventBus.connect("player_hit", shake)
	EventBus.leveled_up.connect(punch_zoom)
	base_zoom = zoom

## quick zoom-in punch that eases back to the base zoom, sells the level-up moment
func punch_zoom(level: int) -> void:
	zoom = base_zoom * (1.0 + level_up_punch_zoom)
	var tween = create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)  # upgrade menu pauses the tree right after this fires
	tween.tween_property(self, "zoom", base_zoom, level_up_punch_duration).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
		offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * shake_max_offset * shake_strength
	else:
		offset = Vector2.ZERO

func shake(amount: float = 10) -> void:
	shake_strength = min(shake_strength + amount, 1.0)
