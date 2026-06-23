extends Node

signal drop_xp(xp_position: Vector2, xp_amount: int)

signal gain_xp(xp_amount : int)

signal xp_changed(xp_amount : int, xp_to_next_level : int)

signal leveled_up(level : int)

signal upgrade_chosen(upgrade : UpgradeBase)

signal game_paused(paused : bool)

signal player_died()

# position is the position that the attack is at, 
# velocity is the velocity of the parent body,
# attack_scene is the packed scene to instantiate,
# attack_team is the team to attack, eg ENEMY would be fired from an enemy and PLAYER would be fired from player
# damage_multiplier is the multiplier for the damage
signal fire_attack(transform: Transform2D, velocity: Vector2, attack_scene: PackedScene, attack_team: String, damage_multiplier : int)

signal wave_started(wave_number: int)
