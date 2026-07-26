extends StateMachineState
class_name Phase1Attack

@export var enemy_fighter_scene : PackedScene

@export var fighter_spawn_1 : Marker2D
@export var fighter_spawn_2 : Marker2D

## half the number of fighters that spawn (one from each spawn)
@export var fighter_number : int = 2

@export var physics_body : CharacterBody2D

@export var ship_data_component : ShipDataComponent

var spawned_enemies = false
var enemies_amount = 0
var can_spawn_enemies = false

var random_coords = Vector2(0, 0)
var at_target_coords



func _process(delta: float) -> void:
	if state_machine_manager.current_state == state_name:
		if !spawned_enemies and can_spawn_enemies:
			spawn_enemies()
		
		if at_target_coords or random_coords == Vector2(0, 0):
			random_coords = Vector2(randi_range(-500, 500), randi_range(-500, 500))
		move_to_coords(physics_body, random_coords, delta, ship_data_component.ship_speed, ship_data_component.ship_agility)


func spawn_enemies():
	if can_spawn_enemies:
		can_spawn_enemies = false
		
		var f1 = enemy_fighter_scene.instantiate()
		var f2 = enemy_fighter_scene.instantiate()
		
		fighter_spawn_1.add_child(f1)
		fighter_spawn_2.add_child(f2)
		
		enemies_amount += 1
		
		if enemies_amount >= fighter_number:
			spawned_enemies = true
			enemies_amount == 0



func move_to_coords(
	node: Node2D, 
	target_pos: Vector2, 
	delta: float, 
	speed: float = 300.0, 
	rotation_speed: float = 5.0, 
	arrival_tolerance: float = 10.0
	) -> void:
	
	var current_pos: Vector2 = node.global_position
	
	# 1. Check if we are close enough to stop
	var distance: float = current_pos.distance_to(target_pos)
	if distance < arrival_tolerance:
		# If it's a CharacterBody2D, safely bring its velocity to zero
		if node is CharacterBody2D:
			node.velocity = Vector2.ZERO
			at_target_coords = true
		return

	# 2. Steer towards the target
	var dir_to_target: Vector2 = current_pos.direction_to(target_pos)
	var target_angle: float = dir_to_target.angle()
	
	# Smoothly interpolate rotation along the shortest arc
	node.global_rotation = rotate_toward(node.global_rotation, target_angle, rotation_speed * delta)

	# 3. Calculate forward throttle
	# Assumes your art faces Right (0 degrees) by default
	var forward_vector: Vector2 = Vector2.RIGHT.rotated(node.global_rotation)
	
	# Scale speed based on alignment: full speed ahead, slow down for sharp hairpin turns
	var alignment_factor: float = max(0.0, forward_vector.dot(dir_to_target))
	var current_velocity: Vector2 = forward_vector * speed * alignment_factor
	
	#print(current_velocity, physics_body.global_position)
	
# Fallback for plain Node2D / Sprites / Area2Ds
	node.global_position += current_velocity * delta


func _on_spawn_delay_timer_timeout() -> void:
	can_spawn_enemies = true


func _on_spawn_wave_timer_timeout() -> void:
	spawned_enemies = false
