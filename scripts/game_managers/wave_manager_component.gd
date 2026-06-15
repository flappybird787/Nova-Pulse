extends Node
class_name WaveManagerComponent

@export var scene_root : Node2D

@export var current_wave_number : int

@export var active_enemies_count : int

@export var wave_configs : Array[WaveConfig]

var active_wave_config : WaveConfig

var active_formation : EnemyFormationBase

var wave_active = false

var active_enemies : Array

func _process(delta: float) -> void:
	if !wave_active:
		start_wave(current_wave_number)
		wave_active = true
	
	active_enemies_count = 0
	
	active_enemies = active_enemies.filter(func(obj): return is_instance_valid(obj))
	
	for enemy in active_enemies:
		active_enemies_count += 1
	
	print("active enemies count: ", active_enemies_count, " active enemies: ", active_enemies)
	
	if active_enemies_count == 0:
		current_wave_number += 1
		wave_active = false

func start_wave(wave_number : int):
	if wave_configs.size() > wave_number:
		active_wave_config = wave_configs[wave_number]
	
	var all_formations = active_wave_config.formation_pool
	
	all_formations.shuffle()
	
	print("formations: ", all_formations)
	
	active_formation = all_formations[0]
	
	var enemies_in_formation = active_formation.enemies_list
	
	for enemy in enemies_in_formation:
		var e = enemy.instantiate()
		scene_root.add_child(e)
		e.global_position = Vector2(randi_range(-800, 800), randi_range(-800, 800))
		active_enemies.append(e)
