extends Node
class_name HitScaleComponent

@export var sprite : Sprite2D

@export var scale_curve : Curve

@export var base_scale = Vector2(1.0, 1.0)

@export var min_scale = 0.5

@export var effect_duration : float

var is_scaling = false

func trigger_scale_effect() -> void:
	if is_scaling:
		return
	if not is_inside_tree():
		return

	is_scaling = true
	var elapsed := 0.0
	var tree := get_tree()

	while elapsed < effect_duration:
		elapsed += get_process_delta_time()
		var t = clamp(elapsed / effect_duration, 0.0, 1.0)
		var curve_value := scale_curve.sample(t)
		var target_scale = base_scale.lerp(base_scale * min_scale, curve_value)

		if not is_instance_valid(sprite):
			is_scaling = false
			return

		sprite.scale = target_scale

		if not is_instance_valid(tree):
			is_scaling = false
			return

		await tree.process_frame

		if not is_instance_valid(self) or not is_instance_valid(sprite):
			return

	if is_instance_valid(sprite):
		sprite.scale = base_scale
	is_scaling = false
