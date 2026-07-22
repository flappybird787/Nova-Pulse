extends StateMachineState
class_name SpawnState

@export var spawn_coords = Vector2(0, 0)

@export var move_to = Vector2(0, 0)

@export var physics_body : CharacterBody2D

@export var ship_data_component : ShipDataComponent

var at_target_coords = false

func _ready() -> void:
	state_machine_manager.set_state(state_name, "")

var at_spawn_cords = false
func _physics_process(delta: float) -> void:
	if !at_spawn_cords:
		physics_body.global_position = spawn_coords
		at_spawn_cords = true
	
	move_to_coords(physics_body, move_to, delta, ship_data_component.ship_speed, ship_data_component.ship_agility)
	
	if at_target_coords:
		state_machine_manager.go_to_next_state("")


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
	
	print(current_velocity, physics_body.global_position)
	
# Fallback for plain Node2D / Sprites / Area2Ds
	node.global_position += current_velocity * delta
