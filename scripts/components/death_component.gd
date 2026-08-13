extends Node
class_name DeathComponent

@export var health_component : HealthComponent
@export var root : Node

@export var xp_on_death : int = 0

## explosion vfx/sfx scene, spawned when this ship dies
@export var explosion_scene : PackedScene

var time = 0.0

@export var is_boss = false

func _process(delta: float) -> void:
	if health_component.health <= 0:
		EventBus.gain_xp.emit(xp_on_death)
		if is_boss:
			EventBus.boss_killed.emit()
		spawn_explosion()
		root.queue_free()


## spawns the explosion at the ship's position, parented to the ship's
## parent (not root itself) so it survives after root is freed
func spawn_explosion() -> void:
	if explosion_scene:
		var explosion = explosion_scene.instantiate()
		root.get_parent().add_child(explosion)
		explosion.global_position = root.global_position
