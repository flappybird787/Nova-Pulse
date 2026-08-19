extends ParallaxBackground
class_name ParallaxFollowComponent

## the node that should drive the scrolling (usually the player ship)
@export var target : Node2D

func _process(delta: float) -> void:
	if target:
		# since the camera itself never moves, we fake the "camera follows player"
		# effect by feeding the ship's position straight into scroll_offset instead
		scroll_offset = -target.global_position
