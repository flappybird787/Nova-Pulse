extends Node
class_name  PlayerShipControllerComponent

## the ship data component for getting ship properties
@export var ship_data_component : ShipDataComponent

## the characterbody2d of the ship
@export var ship_body : CharacterBody2D

var velocity : Vector2

var can_fire = true



@export var primary_weapon_cooldown_timer : Timer

@export var attack_trigger_component : AttackTriggerComponent

@export var health_component : HealthComponent

@export var thrusters : Node2D


func _ready() -> void:
	EventBus.upgrade_chosen.connect(apply_upgrades)
	EventBus.ready_to_level_up.connect(manage_player_level)


func _physics_process(delta: float) -> void:
	get_player_input()
	
	dampen_velocity(delta)
	
	limit_velocity(ship_data_component.ship_speed)
	
	ship_body.velocity = velocity
	
	ship_body.move_and_slide()
	
	if health_component.health <= 0:
		EventBus.player_died.emit()
		get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func get_player_input():
	ship_body.look_at(get_viewport().get_camera_2d().get_global_mouse_position())

	var move_dir = Vector2.ZERO

	thrusters.visible = false

	if Input.is_action_pressed("move_up"):
		move_dir += ship_body.transform.x 
		thrusters.visible = true
		
	if Input.is_action_pressed("move_down"):
		move_dir -= ship_body.transform.x 
		thrusters.visible = true

	if move_dir != Vector2.ZERO:
		move_dir = move_dir.normalized()

	velocity += move_dir * ship_data_component.ship_acceleration 
	
	if Input.is_action_pressed("primary_attack"):
		if can_fire:
			attack_trigger_component.trigger_attack()
			can_fire = false
			primary_weapon_cooldown_timer.start()
	
	if Input.is_action_pressed("level_up") and GameManager.potential_levels > 0:
		EventBus.leveled_up.emit(GameManager.player_level)
		GameManager.potential_levels -= 1


func manage_player_level(level):
	GameManager.potential_levels += 1
	print("can level up ", GameManager.potential_levels, " times")


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


func _on_timer_timeout() -> void:
	can_fire = true


func apply_upgrades(upgrade : UpgradeBase):
	if upgrade.upgrade_name == "Fire Rate Booster":
		if primary_weapon_cooldown_timer.wait_time >= 0.1:
			primary_weapon_cooldown_timer.wait_time *= 0.7
		
		else:
			primary_weapon_cooldown_timer.wait_time = 0.1

	if upgrade.upgrade_name == "Railgun":
		primary_weapon_cooldown_timer.wait_time *= 2
