extends Node
class_name StateMachineManager

## don't set this directly, use set_state() instead
@export var current_state: String

## don't set this directly, use set_state() instead
@export var next_state: String


#func _process(delta: float) -> void:
	#print("current state: ", current_state, " next state: ", next_state)


func set_state(state_to_set, next_state_to_set, interrupt_current = false):
	if interrupt_current or current_state == "":
		current_state = state_to_set

	next_state = next_state_to_set
