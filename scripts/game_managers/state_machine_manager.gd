extends Node
class_name StateMachineManager

## don't set this directly, use set_state() instead
@export var current_state: String

## don't set this directly, use set_state() instead
@export var next_state: String

func set_state(state_to_set, next_state_to_set, interrupt_current = false):
	if interrupt_current or current_state == "":
		current_state = state_to_set

	next_state = next_state_to_set


func go_to_next_state(next_state_to_set):
	current_state = next_state
	next_state = next_state_to_set
