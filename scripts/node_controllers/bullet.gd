extends CharacterBody2D
class_name Bullet

@export var damage = 0

@export var speed = 0

## velocity inherited from whatever fired this
@export var inherited_velocity : Vector2 = Vector2.ZERO

## how much of the parent's velocity to inherit (0 = none, 1 = full)
@export var velocity_inheritance : float = 0.5

## floor on total speed as a fraction of base speed, so a ship moving
## backward relative to the shot can't make it crawl or nearly stall
@export var min_speed_ratio : float = 0.6

## set this to PLAYER or ENEMY
@export var type : String

@export var color_manager_component : ColorManagerComponent


func _physics_process(delta: float) -> void:
	var forward := transform.x

	# only keep the part of the parent's velocity pointing the same way as
	# the shot itself — sideways/backward motion gets dropped instead of
	# fighting the bullet or making it drift off-axis
	var forward_boost := forward.dot(inherited_velocity) * velocity_inheritance

	# clamp so the shot never crawls (or reverses) even if the ship was
	# moving hard against its own firing direction
	var total_speed = max(speed + forward_boost, speed * min_speed_ratio)

	velocity = forward * total_speed

	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()


func _on_player_area_body_entered(body: Node2D) -> void:
	if type == "ENEMY":
		
		body.health_component.deal_damage(damage)
		
		queue_free()


func _on_enemy_area_body_entered(body: Node2D) -> void:
	if type == "PLAYER":
		
		body.health_component.deal_damage(damage)
		
		queue_free()
