extends Node
class_name AttackInstantiatorComponent


func _ready() -> void:
	EventBus.fire_attack.connect(instantiate_attack)

func instantiate_attack(transform: Transform2D, velocity: Vector2, attack_scene: PackedScene, attack_team: String, damage_multiplier : int, color : Color):
	var a = attack_scene.instantiate()
	add_child(a)
	a.transform = transform
	a.inherited_velocity = velocity	# store parent's velocity separately, not into the builtin velocity prop
	a.type = attack_team
	a.damage *= damage_multiplier
	a.color_manager_component.color = color
