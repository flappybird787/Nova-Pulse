extends CharacterBody2D
class_name Bullet

@export var damage = 0

@export var speed = 0

## set this to PLAYER or ENEMY
@export var type : String

func _physics_process(delta: float) -> void:
	velocity = transform.y * speed
	
	move_and_slide()


func _on_timer_timeout() -> void:
	queue_free()


func _on_player_area_body_entered(body: Node2D) -> void:
	if type == "ENEMY":
		print("hit the player")
		
		body.health_component.health -= damage
		
		queue_free()


func _on_enemy_area_body_entered(body: Node2D) -> void:
	if type == "PLAYER":
		print("hit an enemy")
		
		body.health_component.health -= damage
		
		queue_free()
