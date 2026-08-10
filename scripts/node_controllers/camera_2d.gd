extends Camera2D

var shake_strength := 0.0
var shake_decay := 5.0  # how fast the shake fades
var shake_max_offset := 16.0  # max pixels of shake

func _ready() -> void:
	EventBus.connect("player_hit", shake)

func _process(delta: float) -> void:
	if shake_strength > 0.0:
		shake_strength = max(shake_strength - shake_decay * delta, 0.0)
		offset = Vector2(
			randf_range(-1.0, 1.0),
			randf_range(-1.0, 1.0)
		) * shake_max_offset * shake_strength
	else:
		offset = Vector2.ZERO

func shake(amount: float = 1.5) -> void:
	shake_strength = min(shake_strength + amount, 1.0)
