extends Node

@export var player_xp : int

# idfk man i wrote this while i was all half asleep
# so if this code is shit thats why
@export var player_level : int = 1


func _ready() -> void:
	EventBus.player_died.connect(reset_values)


func reset_values():
	player_level = 1
	player_xp = 0
	print("RESET EVERYTHING 1")
