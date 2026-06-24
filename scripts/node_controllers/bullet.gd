extends CharacterBody2D
class_name Bullet

@export var damage = 0

@export var speed = 0

## set this to PLAYER or ENEMY
@export var type : String

@export var color_manager_component : ColorManagerComponent


func _physics_process(delta: float) -> void:
	velocity = transform.x * speed
	
	move_and_slide()


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
