extends Node2D
class_name StarFieldLayer

## how many stars to scatter across this layer
@export var star_count : int = 150

## the tile area stars are scattered within (should match motion_mirroring on the parent ParallaxLayer)
@export var field_size : Vector2 = Vector2(2000, 2000)

## star size range, tweak per layer so "far" layers look smaller/dimmer
@export var min_star_size : float = 1.0
@export var max_star_size : float = 3.0

@export var star_color : Color = Color(1, 1, 1, 0.8)

var _stars : Array = []

func _ready() -> void:
	for i in star_count:
		# stars must span (0,0) to field_size, NOT centered - motion_mirroring
		# tiles starting from the layer's local origin, not symmetrically around it
		var pos = Vector2(
			randf_range(0, field_size.x),
			randf_range(0, field_size.y)
		)
		var size = randf_range(min_star_size, max_star_size)
		_stars.append({"pos": pos, "size": size})
	queue_redraw()

func _draw() -> void:
	for star in _stars:
		draw_circle(star["pos"], star["size"], star_color)
