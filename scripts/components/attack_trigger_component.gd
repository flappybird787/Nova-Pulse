extends Node
class_name AttackTriggerComponent

@export var attack_scene : PackedScene 

@export var position : Marker2D

@export var physics_body : CharacterBody2D

## set this to ENEMY for fired from an enemy or PLAYER for fired from the player
@export var attack_team : String


func trigger_attack():
	EventBus.fire_attack.emit(position.global_transform, physics_body.velocity, attack_scene, attack_team)
