extends Node
class_name MapEdgeOverflowComponent

## the characterbody2d of the ship
@export var ship_body : CharacterBody2D

@export var offset_x = 0.95
@export var offset_y = 0.95

func on_map_edge_overlap_x(area: Area2D):
	ship_body.position.x = -ship_body.position.x * offset_x


func on_map_edge_overlap_y(area: Area2D):
	ship_body.position.y = -ship_body.position.y * offset_y
