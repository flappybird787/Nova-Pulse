extends CharacterBody2D
class_name Turbolaser

@export var damage = 0

@export var speed = 0

## set this to PLAYER or ENEMY
@export var type : String

@export var left : Node2D

@export var right : Node2D

func _physics_process(delta: float) -> void:
	velocity = transform.y * speed
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()


func _on_left_player_area_body_entered(body: Node2D) -> void:
	if type == "ENEMY":
		
		body.health_component.deal_damage(damage)
		
		left.queue_free()


func _on_left_enemy_area_body_entered(body: Node2D) -> void:
	if type == "PLAYER":
		
		body.health_component.deal_damage(damage)
		
		left.queue_free()


func _on_right_player_area_body_entered(body: Node2D) -> void:
	if type == "ENEMY":
		
		body.health_component.deal_damage(damage)
		
		right.queue_free()


func _on_right_enemy_area_body_entered(body: Node2D) -> void:
	if type == "PLAYER":
		
		body.health_component.deal_damage(damage)
		
		right.queue_free()
