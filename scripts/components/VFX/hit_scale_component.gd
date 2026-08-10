extends Node
class_name HitScaleComponent

@export var sprite : Sprite2D

@export var scale_curve : Curve

@export var base_scale = Vector2(1.0, 1.0)

@export var min_scale = 0.5

@export var effect_duration : float

var is_scaling = false

func trigger_scale_effect():

	is_scaling = true
	var elapsed := 0.0

	while elapsed < effect_duration:
		elapsed += get_process_delta_time()
		var t = clamp(elapsed / effect_duration, 0.0, 1.0)

		# curve.sample expects 0-1 input, returns 0-1 output by default
		var curve_value := scale_curve.sample(t)

		# lerp between base_scale and the shrunk scale based on curve value
		var target_scale = base_scale.lerp(base_scale * min_scale, curve_value)
		sprite.scale = target_scale

		await get_tree().process_frame

	sprite.scale = base_scale
	is_scaling = false
