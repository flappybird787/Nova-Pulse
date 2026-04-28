extends Node

## the ship data component for getting ship properties
@export var ship_data_component : ShipDataComponent

## the characterbody2d of the ship
@export var ship_body : CharacterBody2D

var velocity : Vector2

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("move_up"):
		velocity += Vector2(0, 1) * ship_data_component.ship_agility
		
	if Input.is_action_pressed("move_down"):
		velocity += Vector2(0, -1) * ship_data_component.ship_agility
		
	if Input.is_action_pressed("move_left"):
		velocity += Vector2(1, 0) * ship_data_component.ship_agility
		
	if Input.is_action_pressed("move_right"):
		velocity += Vector2(-1, 0) * ship_data_component.ship_agility
		
		ship_body.velocity = velocity
		ship_body.move_and_slide()
