extends Node2D
class_name ExplosionEffect

@export var animation_player : AnimationPlayer

func _ready() -> void:
	# play the death sound and kick off the explosion animation
	AudioStreamManager.play("res://assets/audio/explosion.mp3", 0.5, 100.0)
	animation_player.play("explode")


func _on_animation_player_animation_finished(anim_name: String) -> void:
	# clean up once the explosion has finished playing
	queue_free()
