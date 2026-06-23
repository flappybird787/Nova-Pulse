extends Node
class_name CollisionManagerComponent


@export var health_component : HealthComponent

@export var ship_data_component : ShipDataComponent

@export var ship_body : CharacterBody2D

@export var ship_controller_component : PlayerShipControllerComponent


func _on_ship_collision_area_body_entered(body: Node2D) -> void:
	var damage_dealt = body.health_component.health + body.health_component.shields * (ship_data_component.ship_speed / ship_body.velocity.length())
	
	#body.health_component.deal_damage(damage_dealt)
	
	#health_component.deal_damage(damage_dealt)
