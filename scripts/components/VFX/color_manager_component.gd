extends Node
class_name ColorManagerComponent

@export var sprite : Node2D

@export var trail : Line2D

@export var color : Color

func _process(delta: float) -> void:
	if sprite:
		sprite.modulate = Color(color)
	
	if trail:
		trail.default_color = Color(color, 0.7)
