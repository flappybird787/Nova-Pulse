extends Node
class_name XPComponent

var xp : int

@export var xp_particle  : PackedScene = load("res://prefabs/xp_particle.tscn")

func _ready() -> void:
	EventBus.drop_xp.connect(drop_xp)


func drop_xp(xp_position: Vector2, xp_amount: int):
	print("xp_dropped, pos: ", xp_position, " amount: ", xp_amount)
	var x = xp_particle.instantiate()
	add_child(x)
	x.global_position = xp_position
	x.xp_amount = xp_amount
