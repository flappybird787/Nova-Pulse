extends Node

signal drop_xp(xp_position: Vector2, xp_amount: int)

signal gain_xp(xp_amount : int)

signal xp_changed(xp_amount : int, xp_to_next_level : int)

signal leveled_up(level : int)

# position is the position that the attack is at, 
# velocity is the velocity of the parent body,
# attack_scene is the packed scene to instantiate,
# attack_team is the team to attack, eg ENEMY would be fired from an enemy and PLAYER would be fired from player
signal fire_attack(transform: Transform2D, velocity: Vector2, attack_scene: PackedScene, attack_team: String)
