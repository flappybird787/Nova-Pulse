extends Node
class_name AttackInstantiatorComponent

@export var attack : PackedScene = load("res://prefabs/bullet.tscn")

@export var attack_point : Marker2D

## set this to ENEMY for fired from an enemy or PLAYER for fired from the player
@export var type : String

func instantiate_attack():
	var a = attack.instantiate()
	add_child(a)
	a.transform = attack_point.global_transform
	a.speed = 1200
	a.damage = 1
	a.type = type
