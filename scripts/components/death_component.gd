extends Node
class_name DeathComponent

@export var health_component : HealthComponent
@export var root : Node

@export var xp_component : XPComponent

func _process(delta: float) -> void:
	if health_component.health <= 0:
		EventBus.drop_xp.emit(root.global_position, 5)
		root.queue_free()
