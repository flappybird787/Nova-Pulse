extends StateMachineState
class_name AttackingState


@export var can_attack = false

@export var ship_data_component : ShipDataComponent
@export var ship_base : CharacterBody2D

var target

func _process(delta: float) -> void:
	
	if can_attack:
		state_machine_manager.set_state(state_name, "", true)
	 
	elif !can_attack and state_machine_manager.current_state == state_name: 
		state_machine_manager.set_state(state_machine_manager.next_state, "", true)

	if state_machine_manager.current_state == state_name:
		attack(ship_base, target.global_position, delta, ship_data_component.ship_speed, ship_data_component.ship_agility)

func attack(
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

	# 4. Apply movement based on the node type
	if node is CharacterBody2D:
		node.velocity = current_velocity
		node.move_and_slide()
	else:
		# Fallback for plain Node2D / Sprites / Area2Ds
		node.global_position += current_velocity * delta


func _on_attack_range_body_entered(body: Node2D) -> void:
	can_attack = true
	target = body


func _on_attack_range_body_exited(body: Node2D) -> void:
	can_attack = false
	target = null
