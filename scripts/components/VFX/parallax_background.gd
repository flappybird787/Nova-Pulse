extends ParallaxBackground
class_name ParallaxFollowComponent

## the node that should drive the scrolling (usually the player ship)
@export var target : Node2D

## if the target's position changes by more than this in a single frame, treat
## it as a teleport (eg. the map-edge wraparound) and don't apply that jump to
## the scroll offset — this keeps the starfield still while the ship "wraps"
@export var teleport_threshold : float = 500.0

var _last_target_position : Vector2
var _accumulated_offset : Vector2 = Vector2.ZERO
var _initialized : bool = false

func _process(delta: float) -> void:
	if not target:
		return

	if not _initialized:
		# nothing to compare against on the very first frame
		_last_target_position = target.global_position
		_initialized = true

	var position_delta = target.global_position - _last_target_position

	# normal movement is a small delta each frame; a wrap-around teleport is a
	# huge one, so only fold small deltas into the accumulated scroll offset
	if position_delta.length() < teleport_threshold:
		_accumulated_offset -= position_delta

	_last_target_position = target.global_position
	scroll_offset = _accumulated_offset
