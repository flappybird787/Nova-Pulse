extends Node
class_name GUIManagerComponent

@export var health_component : HealthComponent

@export_group("labels")

@export var shield_bar : ProgressBar

@export var health_bar : ProgressBar

@export var xp_bar : ProgressBar

@export var health_label_pivot : Control

@export var player_labels : Control

@export var wave_label : Label

@export var upgrade_ready_label : Label

## handles the transform of a label, such as a health bar floating above an enemy
@export var is_enemy_gui = false

@export_group("juice")

# ... existing flash/punch exports stay the same ...

## health percentage (0-1) below which the low-health pulse kicks in
@export var low_health_threshold := 0.3

## extra buffer above the threshold before the pulse turns off — prevents
## the fade flickering on/off if health hovers right at the threshold (e.g. from regen ticks)
@export var low_health_hysteresis := 0.05

var _low_health_active := false

# NOTE: this is intentionally never reset to 0. resetting it on every enter/exit
# of the low-health state was causing the "restarts the fade" bug, since the sine
# wave's phase would pop back to its starting point each time
var _pulse_time := 0.0

## how long the hit-flash lasts, in seconds
@export var flash_duration := 0.15

## how bright the overbright flash gets (modulate multiplies color, so >1 is needed
## to actually brighten toward white — 1.0 would be a no-op since that's the default)
@export var flash_brightness := 3.0

## how big the punch scale gets on hit (1.0 = no punch)
@export var punch_scale_amount := 1.15

## how long the punch scale animation takes to settle
@export var punch_duration := 0.2


var showing : bool = true

# previous values, used to detect a *drop* (damage) vs regen ticking up
var _prev_health : float = -1.0
var _prev_shields : float = -1.0

# separate tween refs per bar so a rapid second hit doesn't fight the first animation
var health_flash_tween : Tween
var health_punch_tween : Tween
var shield_flash_tween : Tween
var shield_punch_tween : Tween


func _ready() -> void:
	EventBus.xp_changed.connect(handle_xp_labels)
	EventBus.game_paused.connect(handle_labels_visibility)
	EventBus.wave_started.connect(handle_wave_number)


func _process(delta: float) -> void:
	handle_health_labels()
	handle_xp_labels(GameManager.player_xp, PlayerUpgradeManager.xp_to_next_level)
	handle_low_health_pulse(delta)
	if GameManager.potential_levels > 0:
		upgrade_ready_label.show()

	else:
		upgrade_ready_label.hide()


func handle_labels_visibility(paused : bool):
	if !paused:
		player_labels.show()

	if paused:
		player_labels.hide()


func handle_xp_labels(xp_amount, xp_to_next_level):
	xp_bar.value = lerp(xp_bar.value, float(xp_amount), 0.1)
	xp_bar.max_value = xp_to_next_level


func handle_health_labels():
	if health_component.max_shields != 0:
		# fire hit feedback the frame shields actually drop, before we overwrite _prev_shields
		if _prev_shields != -1.0 and health_component.shields < _prev_shields:
			trigger_hit_feedback(shield_bar, "shield")
		_prev_shields = health_component.shields

		shield_bar.value = lerp(shield_bar.value, float(health_component.shields), 0.1)
		shield_bar.max_value = health_component.max_shields

	if health_component.max_health != 0:
		if _prev_health != -1.0 and health_component.health < _prev_health:
			trigger_hit_feedback(health_bar, "health")
		_prev_health = health_component.health

		health_bar.value = lerp(health_bar.value, float(health_component.health), 0.1)
		health_bar.max_value = health_component.max_health

	if is_enemy_gui:
		handle_label_gui_position()


func handle_label_gui_position():
	health_label_pivot.rotation = -get_parent().rotation


## flashes + punch-scales the given bar to sell a hit. "which" just picks the tween slot
## so health and shield hits don't cancel each other's animations.
func trigger_hit_feedback(bar: ProgressBar, which: String) -> void:
	var flash_tween = health_flash_tween if which == "health" else shield_flash_tween
	var punch_tween = health_punch_tween if which == "health" else shield_punch_tween

	# kill any in-flight tweens so rapid hits restart cleanly instead of stacking
	if flash_tween:
		flash_tween.kill()
	if punch_tween:
		punch_tween.kill()

	# snap to an overbright multiplier, then ease back down to normal (1,1,1,1).
	# modulate multiplies the existing color, so >1 is required to actually brighten it
	bar.modulate = Color(flash_brightness, flash_brightness, flash_brightness, 1.0)
	flash_tween = create_tween()
	flash_tween.tween_property(bar, "modulate", Color(1, 1, 1, 1), flash_duration)

	# punch scale: snap bigger, spring back down
	bar.pivot_offset = bar.size / 2
	bar.scale = Vector2.ONE * punch_scale_amount
	punch_tween = create_tween()
	punch_tween.tween_property(bar, "scale", Vector2.ONE, punch_duration).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

	if which == "health":
		health_flash_tween = flash_tween
		health_punch_tween = punch_tween
	else:
		shield_flash_tween = flash_tween
		shield_punch_tween = punch_tween

## subtle alpha pulse on the health bar when low, to nudge the player without being obnoxious
func handle_low_health_pulse(delta: float) -> void:
	if health_component.max_health == 0:
		return

	var health_pct = float(health_component.health) / float(health_component.max_health)

	# keep the clock running continuously so re-entering low health doesn't pop the phase
	_pulse_time += delta

	# hysteresis: once low, stay low until healed past threshold + buffer.
	# stops rapid flicker in/out right at the boundary
	if not _low_health_active and health_pct <= low_health_threshold and health_pct > 0.0:
		_low_health_active = true
	elif _low_health_active and health_pct > low_health_threshold + low_health_hysteresis:
		_low_health_active = false

	if _low_health_active:
		# severity ramps 0 -> 1 as health approaches 0, speeding up the pulse
		var severity = clamp(1.0 - (health_pct / low_health_threshold), 0.0, 1.0)
		var pulse_speed = lerp(4.0, 8.0, severity)
		var alpha = 0.8 + sin(_pulse_time * pulse_speed) * 0.2
		health_bar.self_modulate.a = alpha
	else:
		health_bar.self_modulate.a = 1.0

func handle_wave_number(wave_number):
	wave_label.text = str("WAVE ", wave_number)
