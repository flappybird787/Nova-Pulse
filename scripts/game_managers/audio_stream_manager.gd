extends Node

var num_players = 8
var bus = "master"

var available = []  # The available players.
var queue = []  # The queue of sounds to play, as {sound_path, fade_time, id} dicts.

var default_fade_time = 0.5  # Fallback fade in/out duration (seconds) when none is given.

var _next_id = 0  # Counter used to hand out unique play IDs.


func _ready():
	# Create the pool of AudioStreamPlayer nodes.
	for i in num_players:
		var player = AudioStreamPlayer.new()
		add_child(player)
		available.append(player)
		player.finished.connect(_on_stream_finished.bind(player))
		player.bus = bus


func _on_stream_finished(stream):
	# When finished playing a stream, clear its ID and make the player available again.
	stream.set_meta("play_id", -1)
	available.append(stream)


func play(sound_path, fade_in_time = default_fade_time):
	# Queue a sound to be played. Returns an ID you can pass to stop() later.
	var id = _next_id
	_next_id += 1
	queue.append({"sound_path": sound_path, "fade_time": fade_in_time, "id": id})
	return id


func _process(delta):
	# Play a queued sound if any players are available.
	if not queue.is_empty() and not available.is_empty():
		var player = available[0]
		available.pop_front()

		var entry = queue.pop_front()
		player.stream = load(entry["sound_path"])
		player.set_meta("play_id", entry["id"])  # Tag the player so it can be found by stop().
		player.volume_db = -80  # Start silent for fade in.
		player.play()

		# Fade in from silence to full volume.
		var tween = create_tween()
		tween.tween_property(player, "volume_db", 0, entry["fade_time"])


func stop(id, fade_out_time = default_fade_time):
	# Fade out and stop the player currently playing the given ID (from play()'s return value).
	for player in get_children():
		if player is AudioStreamPlayer and player.get_meta("play_id", -1) == id:
			_fade_out_and_stop(player, fade_out_time)
			return


func stop_all(fade_out_time = default_fade_time):
	# Fade out and stop every currently playing player.
	for player in get_children():
		if player is AudioStreamPlayer and player.playing:
			_fade_out_and_stop(player, fade_out_time)


func _fade_out_and_stop(player, fade_out_time):
	# Shared helper: tween a player's volume down, then stop it.
	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, fade_out_time)
	tween.tween_callback(player.stop)
