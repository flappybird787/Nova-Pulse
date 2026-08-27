extends CanvasLayer

## handles fading the screen to black between scenes, and fading back in
## also stops all currently playing sounds during the fade out, so loops
## like the player thruster don't keep playing into the next scene

@export var fade_duration : float = 0.5

var fade_rect : ColorRect

func _ready() -> void:
	layer = 128  # render on top of everything
	process_mode = Node.PROCESS_MODE_ALWAYS  # keep working even if the tree is paused

	fade_rect = ColorRect.new()
	fade_rect.color = Color(0, 0, 0, 0)  # starts fully transparent
	fade_rect.anchor_right = 1.0
	fade_rect.anchor_bottom = 1.0
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(fade_rect)


func change_scene(path: String) -> void:
	# fade out, swap the scene, then fade back in
	await fade_out()
	get_tree().change_scene_to_file(path)
	await get_tree().process_frame  # let the new scene finish loading in
	await fade_in()
	get_tree().paused = false


func fade_out() -> void:
	# block input while the fade is happening
	fade_rect.mouse_filter = Control.MOUSE_FILTER_STOP

	# fade out any playing sounds (eg. the thruster loop) alongside the screen
	AudioStreamManager.stop_all(fade_duration)

	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 1.0, fade_duration)
	await tween.finished


func fade_in() -> void:
	var tween = create_tween()
	tween.tween_property(fade_rect, "color:a", 0.0, fade_duration)
	await tween.finished
	fade_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
