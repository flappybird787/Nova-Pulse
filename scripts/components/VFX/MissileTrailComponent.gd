extends Node
class_name MissileTrailComponent

@export var missile_trail : Line2D

@export var missile_trail_points_amount : int = 0
@export var trail_spawn_point : Marker2D


func _physics_process(delta: float) -> void:
	missile_trail.add_point(trail_spawn_point.global_position)
	
	if missile_trail.get_point_count() > missile_trail_points_amount:
		missile_trail.remove_point(0)
