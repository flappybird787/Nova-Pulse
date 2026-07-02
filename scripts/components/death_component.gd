extends Node
class_name DeathComponent

@export var health_component : HealthComponent
@export var root : Node

@export var xp_on_death : int = 0

var time = 0.0

func _process(delta: float) -> void:
	if health_component.health <= 0:
		EventBus.gain_xp.emit(xp_on_death)
		root.queue_free()
