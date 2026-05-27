extends Node
class_name AttackInstantiatorComponent

@export var attack : PackedScene = load("res://prefabs/bullet.tscn")

@export var attack_point : Marker2D

@export var physics_body : CharacterBody2D

## set this to ENEMY for fired from an enemy or PLAYER for fired from the player
@export var type : String

@export_enum("BLASTER") var attack_type : String

@export_category("blasters")

@export var speed = 0
@export var damage = 0

func instantiate_attack():
	var a = attack.instantiate()
	add_child(a)
	a.transform = attack_point.global_transform
	if attack_type == "BLASTER":
		a.speed = speed
		a.damage = damage
		a.velocity = physics_body.velocity
	a.type = type
