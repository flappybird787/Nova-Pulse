extends Node

var num_players = 32
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
	_kill_active_tween(stream)
	if not available.has(stream):
		available.append(stream)


func play(sound_path, fade_in_time = default_fade_time, volume_db = 0.0):
	# queue a sound to be played, returns an ID you can pass to stop() later
	# volume_db lets a specific call boost/cut this sound relative to others
	var id = _next_id
	_next_id += 1

	# if a player is free right now, start it immediately instead of waiting for _process
	if not available.is_empty():
		var player = available[0]
		available.pop_front()
		_start_player(player, sound_path, fade_in_time, id, volume_db)  # pass volume_db through
	else:
		queue.append({"sound_path": sound_path, "fade_time": fade_in_time, "id": id, "volume_db": volume_db})  # was missing volume_db

	return id


func _start_player(player, sound_path, fade_in_time, id, volume_db):
	# Shared helper: assigns the stream/id and either fades in or plays instantly.
	# kill any leftover tween from this player's previous sound before reusing it,
	# otherwise an old fade-out tween can silence/cut this new sound off later
	_kill_active_tween(player)

	player.stream = load(sound_path)
	player.set_meta("play_id", id)  # Tag the player so it can be found by stop().

	if fade_in_time > 0:
		player.volume_db = -80  # Start silent for fade in.
		player.play()
		var tween = create_tween()
		tween.tween_property(player, "volume_db", volume_db, fade_in_time)  # fade to the requested volume, not always 0
		player.set_meta("active_tween", tween)
	else:
		# no fade, play at the requested volume right away
		player.volume_db = volume_db
		player.play()


func _process(delta):
	# play a queued sound if any players are available
	if not queue.is_empty() and not available.is_empty():
		var player = available[0]
		available.pop_front()

		var entry = queue.pop_front()
		player.stream = load(entry["sound_path"])
		player.set_meta("play_id", entry["id"])  # tag the player so it can be found by stop()
		player.volume_db = -80  # start silent for fade in

		player.play()

		# fade in from silence up to this sound's target volume
		var tween = create_tween()
		tween.tween_property(player, "volume_db", entry["volume_db"], entry["fade_time"])

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
	# manually calling stop() does NOT emit "finished", so we have to
	# return the player to the pool ourselves or it's lost forever
	_kill_active_tween(player)

	player.set_meta("play_id", -1)
	if not available.has(player):
		available.append(player)

	var tween = create_tween()
	tween.tween_property(player, "volume_db", -80, fade_out_time)
	tween.tween_callback(player.stop)
	player.set_meta("active_tween", tween)


func _kill_active_tween(player):
	# stops a lingering tween (e.g. an old fade-out) from continuing to run
	# and interfering with this player after it's been reused
	if not player.has_meta("active_tween"):
		return

	var old_tween = player.get_meta("active_tween")
	if old_tween and old_tween.is_valid():
		old_tween.kill()
