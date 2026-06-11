extends CharacterBody2D
class_name Missile

@export var damage = 0

@export var speed = 0

@export var guidance_speed = 0

## set this to PLAYER or ENEMY
@export var type : String

var target = null

func _ready() -> void:
	target = get_closest_enemy()

func _physics_process(delta: float) -> void:
	if is_instance_valid(target):
		# 1. Find the angle to the target
		var direction_to_target: Vector2 = (target.global_position - global_position).normalized()
		var target_angle: float = direction_to_target.angle()
		
		# 2. Smoothly rotate towards the target angle
		rotation = rotate_to_angle(rotation, target_angle, guidance_speed * delta)
	
	# 3. Move forward in the direction the missile is currently facing
	velocity = Vector2.RIGHT.rotated(rotation) * speed
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


func get_closest_enemy() -> Node2D:
	var enemies: Array[Node] = get_tree().get_nodes_in_group("ENEMIES")
	
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
