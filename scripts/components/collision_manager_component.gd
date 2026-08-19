extends Node
class_name CollisionManagerComponent


@export var health_component : HealthComponent

@export var ship_data_component : ShipDataComponent

@export var ship_body : CharacterBody2D

@export var ship_controller_component : PlayerShipControllerComponent

## damage dealt to (and taken from) whatever we ram into
@export var ram_damage : int = 8

## how far to instantly shove both ships apart on impact, so they
## don't end up stacked inside each other after colliding
@export var bounce_distance : float = 40.0


func _on_ship_collision_area_body_entered(body: Node2D) -> void:
	# only ram enemies - ignore anything else that might end up on this layer
	if not body.is_in_group("ENEMY"):
		return

	# ram damage goes both ways - we hurt them, they hurt us.
	# health_component.deal_damage() already respects i-frames on both sides
	body.health_component.deal_damage(ram_damage)
	health_component.deal_damage(ram_damage)

	# shove both ships apart along the collision axis so they separate
	# instead of overlapping / getting stuck inside each other
	var push_dir = (ship_body.global_position - body.global_position).normalized()
	if push_dir == Vector2.ZERO:
		push_dir = Vector2.RIGHT  # fallback if they somehow spawned perfectly stacked

	ship_body.global_position += push_dir * bounce_distance
	body.global_position -= push_dir * bounce_distance
