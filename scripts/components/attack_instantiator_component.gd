extends Node
class_name AttackInstantiatorComponent


func _ready() -> void:
	EventBus.fire_attack.connect(instantiate_attack)

func instantiate_attack(transform: Transform2D, velocity: Vector2, attack_scene: PackedScene, attack_team: String):
	var a = attack_scene.instantiate()
	add_child(a)
	a.transform = transform
	a.velocity = velocity
	a.type = attack_team
