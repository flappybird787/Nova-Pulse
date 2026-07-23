extends StateMachineState
class_name Phase1Attack

@export var enemy_fighter_scene : PackedScene

@export var fighter_spawn_1 : Marker2D
@export var fighter_spawn_2 : Marker2D

## half the number of fighters that spawn (one from each spawn)
@export var fighter_number : int = 2

var spawned_enemies = false
var enemies_amount = 0
var can_spawn_enemies = false

func _process(delta: float) -> void:
	if state_machine_manager.current_state == state_name:
		if !spawned_enemies and can_spawn_enemies:
			spawn_enemies()


func spawn_enemies():
	if can_spawn_enemies:
		var f1 = enemy_fighter_scene.instantiate()
		var f2 = enemy_fighter_scene.instantiate()
		
		fighter_spawn_1.add_child(f1)
		fighter_spawn_2.add_child(f2)
		
		enemies_amount += 1
		
		can_spawn_enemies = false
		
		if enemies_amount >= fighter_number:
			spawned_enemies = true
			enemies_amount == 0


func _on_spawn_delay_timer_timeout() -> void:
	can_spawn_enemies = true


func _on_spawn_wave_timer_timeout() -> void:
	spawned_enemies = false
