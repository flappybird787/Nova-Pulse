extends ParallaxBackground
class_name MenuParallaxMouseComponent

## how far the layers shift per pixel the mouse moves
@export var strength: Vector2 = Vector2(0.05, 0.05)

## how quickly the offset eases toward the accumulated target (higher = snappier)
@export var smoothing: float = 5.0

var _last_mouse_pos: Vector2
var _accumulated_offset: Vector2 = Vector2.ZERO
var _initialized: bool = false

func _input(event: InputEvent) -> void:
	if not event is InputEventMouseMotion:
		return

	if not _initialized:
		# first real motion event - this is the true starting position,
		# unlike get_mouse_position() which can be stale (0,0) until the
		# mouse actually moves, causing a fake huge delta on first movement
		_last_mouse_pos = event.position
		_initialized = true
		return

	var mouse_delta = event.position - _last_mouse_pos
	_last_mouse_pos = event.position

	# negative sign so background drifts opposite the mouse, like real parallax
	_accumulated_offset -= mouse_delta * strength

func _process(delta: float) -> void:
	if not _initialized:
		return

	# smoothly ease toward the accumulated target instead of snapping
	scroll_offset = scroll_offset.lerp(_accumulated_offset, smoothing * delta)
