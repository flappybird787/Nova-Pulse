extends CharacterBody2D
class_name Missile

@export var damage = 0

@export var speed = 0

@export var starting_speed = 0

@export var acceleration_curve : Curve

@export var acceleration_time = 0

@export var guidance_speed = 0.0

## set this to PLAYER or ENEMY
@export var type : String

var target = null

var time_alive = 0.0

var spawned = false

func _physics_process(delta: float) -> void:
	
	if !spawned:
		#rotation_degrees += randi_range(-10, 10)
		spawned = true
	
	if type == "PLAYER":
		guidance_speed = 0.3
	
	if target == null:
		target = get_closest_enemy(type)
	
	time_alive += delta
	var t: float = clamp(time_alive / acceleration_time, 0.0, 1.0)

	# Sample the curve value (returns 0.0 to 1.0 based on your graph)
	var curve_t: float = acceleration_curve.sample(t) if acceleration_curve else t

	var current_speed: float = lerp(starting_speed, speed, curve_t)
	
	if is_instance_valid(target):
		# 1. Find the angle to the target
		var direction_to_target: Vector2 = (target.global_position - global_position).normalized()
		var target_angle: float = direction_to_target.angle()
		
		# 2. Smoothly rotate towards the target angle
		rotation = rotate_to_angle(rotation, target_angle, guidance_speed * delta * velocity.length() / 100)
	
	# 3. Move forward in the direction the missile is currently facing
	velocity = Vector2.RIGHT.rotated(rotation) * current_speed
	move_and_slide()

## Helper function to rotate towards an angle without overshooting
func rotate_to_angle(current_angle: float, target_angle: float, max_step: float) -> float:
	# angle_to_turn() automatically handles the -PI to PI wrap-around logic
	var angle_diff: float = angle_difference(current_angle, target_angle)
	return current_angle + clamp(angle_diff, -max_step, max_step)


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


func get_closest_enemy(group) -> Node2D:
	var enemies : Array
	if group == "PLAYER":
		enemies = get_tree().get_nodes_in_group("ENEMY")
	
	elif group == "ENEMY":
		enemies = get_tree().get_nodes_in_group("PLAYER")
	
	print("group: ", group, " enemies: ", enemies)
	if enemies.is_empty():
		return null
	
	var closest_enemy: Node2D = null
	var shortest_distance: float = INF 
	
	for enemy in enemies:
		if enemy is Node2D:
			# The correct Godot 4 method name is distance_squared_to()
			var distance_to_enemy = global_position.distance_to(enemy.global_position)
			
			if distance_to_enemy < shortest_distance:
				closest_enemy = enemy
			
	return closest_enemy
