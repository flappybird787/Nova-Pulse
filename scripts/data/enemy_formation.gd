extends Resource
class_name EnemyFormationBase

@export var enemies_list : Array[PackedScene]

@export var min_spawn_wave : int = 1

@export_enum("RANDOM", "LINE", "SERIES", "OFFSCREENR") var spawn_layout 
