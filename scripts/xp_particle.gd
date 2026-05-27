extends CharacterBody2D
class_name XPParticle

@export var xp_amount : int

var player_in_range = false
var player


func _physics_process(delta: float) -> void:
	if player:
		global_position = global_position.lerp(player.global_position, 1 * delta)

	move_and_slide()
	print(player, "xpx")


func _on_player_detection_area_body_entered(body: Node2D) -> void:
	player_in_range = true
	player = body
