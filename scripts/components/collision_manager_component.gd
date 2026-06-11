extends Node
class_name CollisionManagerComponent


@export var health_component : HealthComponent

@export var ship_data_component : ShipDataComponent

@export var ship_body : CharacterBody2D

@export var ship_controler_component : Playershi


func _on_ship_collision_area_body_entered(body: Node2D) -> void:
	var damage_dealt = body.health_component.max_health + body.health_component.max_shields * (ship_data_component.ship_speed / ship_body.velocity.length())
	
	body.health_component.deal_damage(damage_dealt)

	# 1. Get the direction
	var direction = ship_body.velocity.normalized()

	# 2. Calculate the new length
	var new_length = ship_body.velocity.length() - damage_dealt

	# 3. Combine them
	ship_data_component.slowed_speed /= new_length

	print("damage dealt: ", damage_dealt)
