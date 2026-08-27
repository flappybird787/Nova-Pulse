extends CharacterBody2D
class_name Missile

@export var damage = 0

@export var speed = 0

@export var starting_speed = 0

@export var acceleration_curve : Curve

@export var acceleration_time = 0

@export var guidance_speed = 0.0

## how much the missile's approach angle wobbles, in degrees
@export var wobble_amount : float = 18.0

## how fast the wobble oscillates
@export var wobble_frequency : float = 5.0

## distance from target at which wobble fully fades out, so the final
## approach is clean and the missile actually connects instead of missing wide
@export var wobble_falloff_distance : float = 250.0

# random phase per-missile so a salvo doesn't all wobble in perfect sync
var wobble_seed : float = 0.0

## set this to PLAYER or ENEMY
@export var type : String

var target = null

var time_alive = 0.0

var spawned = false

@export var color_manager_component : ColorManagerComponent

## velocity inherited from whatever fired this
@export var inherited_velocity : Vector2 = Vector2.ZERO

## how much of the parent's velocity to inherit
@export var velocity_inheritance : float = 0.5

## floor on total speed as a fraction of the curve-driven speed
@export var min_speed_ratio : float = 0.7

## camera used to check if the missile is still visible - cached on first use
var _camera : Camera2D

## once true, the missile stops homing entirely and just flies straight -
## set when it leaves the visible screen area, so it can't loop back into view
var off_screen := false

## extra buffer (world units) added around the camera's visible area before
## a missile counts as "off screen" - avoids flickering the tracking on/off
## right at the edge of the view
@export var offscreen_margin : float = 150.0


func _ready() -> void:
	# randomize so multiple missiles fired together don't wobble identically
	wobble_seed = randf() * TAU


func _physics_process(delta: float) -> void:
	
	if !spawned:
		#rotation_degrees += randi_range(-10, 10)
		spawned = true
	
	if type == "PLAYER":
		guidance_speed = 0.3
	
	# once a missile leaves the screen, stop it from homing so it can't
	# loop back around and reappear later - it'll just fly straight until
	# the Timer frees it
	if not off_screen and _is_off_screen():
		off_screen = true
		target = null
	
	if target == null and not off_screen:
		target = get_closest_enemy(type)
	
	time_alive += delta
	var t: float = clamp(time_alive / acceleration_time, 0.0, 1.0)

	# Sample the curve value (returns 0.0 to 1.0 based on your graph)
	var curve_t: float = acceleration_curve.sample(t) if acceleration_curve else t

	var current_speed: float = lerp(starting_speed, speed, curve_t)
	
	if is_instance_valid(target) and not off_screen:
		# 1. find the angle to the target
		var direction_to_target: Vector2 = (target.global_position - global_position).normalized()
		var target_angle: float = direction_to_target.angle()

		# 2. layer a sine wobble on top of the target angle, so the flight path weaves
		var distance_to_target: float = global_position.distance_to(target.global_position)
		var wobble_falloff: float = clamp(distance_to_target / wobble_falloff_distance, 0.0, 1.0)
		var wobble_offset: float = sin(time_alive * wobble_frequency + wobble_seed) * deg_to_rad(wobble_amount) * wobble_falloff
		var wobbled_target_angle: float = target_angle + wobble_offset

		# 3. smoothly rotate towards the wobbled angle instead of the raw one
		rotation = rotate_to_angle(rotation, wobbled_target_angle, guidance_speed * delta * velocity.length() / 100)
		
	# 4. Move forward in the direction the missile is currently facing
	var forward := Vector2.RIGHT.rotated(rotation)
	var forward_boost := forward.dot(inherited_velocity) * velocity_inheritance
	var total_speed = max(current_speed + forward_boost, current_speed * min_speed_ratio)
	velocity = forward * total_speed
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
	
	#print("group: ", group, " enemies: ", enemies)
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


## returns true if the missile has flown outside the current camera's view
func _is_off_screen() -> bool:
	if not _camera:
		_camera = get_viewport().get_camera_2d()
	if not _camera:
		return false

	var viewport_size := get_viewport_rect().size
	# convert screen size to world units via zoom, then add the margin
	var half_extents := (viewport_size / 2.0) / _camera.zoom + Vector2(offscreen_margin, offscreen_margin)
	var cam_pos := _camera.global_position

	return absf(global_position.x - cam_pos.x) > half_extents.x or absf(global_position.y - cam_pos.y) > half_extents.y
