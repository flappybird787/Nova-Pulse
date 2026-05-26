extends Node

## the ship data component for getting ship properties
@export var ship_data_component : ShipDataComponent

## the characterbody2d of the ship
@export var ship_body : CharacterBody2D

@export var attack_instantiator_component : AttackInstantiatorComponent

var velocity : Vector2

func _physics_process(delta: float) -> void:
	get_player_input()
	
	dampen_velocity(delta)
	
	limit_velocity(ship_data_component.ship_speed)
	
	ship_body.velocity = velocity
	ship_body.move_and_slide()


func get_player_input():
	# 1. Rotate the ship to face the mouse first
	ship_body.look_at(get_viewport().get_camera_2d().get_global_mouse_position())

	var move_dir = Vector2.ZERO

	# 2. Use the ship's local transform vectors for direction
	# transform.x is "Forward" because look_at() aligns the +X axis with the mouse
	if Input.is_action_pressed("move_up"):
		move_dir += ship_body.transform.x # Forward
	if Input.is_action_pressed("move_down"):
		move_dir -= ship_body.transform.x # Backward
	if Input.is_action_pressed("move_left"):
		move_dir -= ship_body.transform.y # Strafe Left
	if Input.is_action_pressed("move_right"):
		move_dir += ship_body.transform.y # Strafe Right

	# 3. Normalize to keep diagonal speed consistent
	if move_dir != Vector2.ZERO:
		move_dir = move_dir.normalized()

	# 4. Apply acceleration
	velocity += move_dir * ship_data_component.ship_acceleration
	
	if Input.is_action_pressed("primary_attack"):
		attack_instantiator_component.instantiate_attack()

func limit_velocity(max_velocity):
	if velocity.x > max_velocity:
		velocity.x = max_velocity
		
	if velocity.y > max_velocity:
		velocity.y = max_velocity
		
	if velocity.x < -max_velocity:
		velocity.x = -max_velocity
		
	if velocity.y < -max_velocity:
		velocity.y = -max_velocity


func dampen_velocity(delta, friction: float = 0.01):
	if velocity.length() > 0:
		velocity = velocity.lerp(Vector2.ZERO, friction * delta * 60)
		
		# Optional: Snap to zero if velocity is very low to prevent "infinite" sliding
		if velocity.length() < 0.1:
			velocity = Vector2.ZERO
