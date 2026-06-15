extends Resource
class_name WaveConfig

@export var wave_number : int

## all possible enemy formations for this wave
@export var formation_pool : Array[EnemyFormationBase]

## the number of enemy formations to spawn
@export var formations_number : int = 1
