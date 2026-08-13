extends CharacterBody2D

@export var health_component : HealthComponent

## time to wait after spawning before the enemy starts fading in
@export var spawn_delay : float = 0.75

## how long the fade-in / scale-in animation takes
@export var fade_in_duration : float = 1.0

func _ready() -> void:
	play_spawn_intro()

## hides the enemy on spawn, waits, then fades/scales it in, and only
## lets it start attacking once the whole intro has finished
func play_spawn_intro() -> void:
	var sprite = get_node_or_null("Sprite2D")
	var attack_range = get_node_or_null("AttackRange")
	var fire_range = get_node_or_null("FireRange")

	# disable attack detection right away, re-enabled once the intro finishes
	if attack_range:
		attack_range.monitoring = false
	if fire_range:
		fire_range.monitoring = false

	# start fully invisible and shrunk down
	modulate.a = 0.0
	var base_scale = Vector2.ONE
	if sprite:
		base_scale = sprite.scale
		sprite.scale = Vector2.ZERO

	# the "spawning" pause before anything visually appears
	await get_tree().create_timer(spawn_delay).timeout

	# bail out if the ship got freed while we were waiting
	if !is_inside_tree():
		return

	# fade + scale in together
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "modulate:a", 1.0, fade_in_duration)
	if sprite:
		tween.tween_property(sprite, "scale", base_scale, fade_in_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	await tween.finished

	if !is_inside_tree():
		return

	# only now can the enemy detect and attack the player
	if attack_range:
		attack_range.monitoring = true
	if fire_range:
		fire_range.monitoring = true
