extends Control

@export var hit_radius: float = 45.0
@export var mode: String = "practice"
@export var show_moving_circle_in_challenge: bool = true  # 🔹 toggle for testing

@onready var moving_circle = get_node("MovingCircle")
@onready var animation_player = moving_circle.get_node("AnimationPlayer2")
@onready var effects_container = get_node("EffectsContainer")
@onready var metronome = get_node("Metronome")
@onready var hitline_sprite = get_node("HitLine/Sprite2D")
@onready var miss_effect_scene = preload("res://Scenes/Shared/MissEffect.tscn")
@onready var hit_effect_scene = preload("res://Scenes/Shared/HitEffect.tscn")
@onready var left_pad = get_node("LeftPad")
@onready var right_pad = get_node("RightPad")
@onready var note_pattern_label = get_node("NotePatternLabel")
@onready var bpm_label = get_node("BPMLabel")
@onready var bpm_menu_button = get_node("BPMMenuButton")
@onready var countdown_label = get_node("CountdownLabel")
@onready var countdown_audio_player = get_node("CountdownAudioPlayer")
@onready var pass_sound = get_node("PassSound")
@onready var fail_sound = get_node("FailSound")

@onready var con_texture = preload("res://Assets/Continue.png")
@onready var end_texture = preload("res://Assets/End.png")

# 🔊 Use this AudioStreamPlayer node (child of GameScene) for your mp3 clicks
@onready var bpm_audio: AudioStreamPlayer = $BPMAudio

@onready var touchpad_container = get_node("TouchPadContainer")


@onready var bar_offsets := {
	"continue": Vector2(0, 0),   # perfectly aligned at origin
	"end": Vector2(49, -1)       # the adjustment you tested
}


const BPM_AUDIO_PATHS := {
	60: "res://Assets/NewBPM/metronome_60.wav",
	80: "res://Assets/NewBPM/metronome_80.wav",
	100: "res://Assets/NewBPM/metronome_100.wav"
}

# how many times to play the single-bar audio per BPM (4 bars per BPM)
var bars_played: int = 0
# uses bars_per_bpm already defined above (default 4)


var notes: Array[Node2D] = []
var tick_counter: int = 0                       # counts beats within current bar (resets at bar end)
var drum_module: DrumModuleData
var current_bar_index: int = 0                  # 0..N where N == number of continue bars (N is end bar index)
var beats_to_cover: int = 4                     # beats per bar
var moving_circle_duration: float
var challenge_mode_has_ended := false
var bpm_sequence: Array[int] = [60, 80, 100]
var current_bpm_index: int = 0
var bars_per_bpm: int = 4                       # expected bars per BPM (3 continue + 1 end)

# 🎯 Challenge Mode Scoring
var total_notes := 0
var total_hits := 0
var total_misses := 0
var grade: String

# ⏳ Gate ticks during countdown so bars don’t advance
var in_countdown := false


# -----------------------
func _ready() -> void:
	GlobalAudio.mute_bgm(true)
	transition_anim()
	await  transition_anim()
	drum_module = GameState.selected_module
	if not drum_module:
		push_error("No module selected!")
		return

	# 🚫 Disable BPM menu in challenge mode
	"""if mode == "challenge" and bpm_menu_button:
		bpm_menu_button.disabled = true"""

	# MovingCircle visible in practice or when testing toggle is on
	moving_circle.visible = (mode == "practice") or show_moving_circle_in_challenge
	#hitline_sprite.modulate = Color("#30160D")
	note_pattern_label.visible = false
	countdown_label.visible = true

	# Silence the metronome's internal tick sound (we’ll use BPMAudio mp3s for sound)
	var tick_node := metronome.get_node_or_null("TickSound")
	if tick_node and tick_node is AudioStreamPlayer2D:
		tick_node.stream = null  # prevents Metronome.play_tick() from making sound

	# Start at the first BPM in the sequence
	current_bpm_index = 0
	var start_bpm: int = bpm_sequence[current_bpm_index]
	bpm_label.text = "BPM: %d" % start_bpm
	moving_circle_duration = (60.0 / float(start_bpm)) * beats_to_cover

	# --- NEW: compute total_notes ONCE for challenge mode
	if mode == "challenge":
		var per_bpm_note_count = compute_total_notes_from_module()
		total_notes = per_bpm_note_count * bpm_sequence.size()
		print("🔢 Total notes computed:", total_notes, "(per BPM:", per_bpm_note_count, "x", bpm_sequence.size(), "BPMs)")

# ensure bpm_audio exists and connect its finished signal (safe connect)
	if bpm_audio and not bpm_audio.is_connected("finished", Callable(self, "_on_bpm_audio_finished")):
		bpm_audio.connect("finished", Callable(self, "_on_bpm_audio_finished"))


	# Countdown first (no movement)
	await play_countdown(start_bpm)

	# Start timing (metronome timer drives ticks), and play mp3 click
	metronome.start(start_bpm, mode)
	play_bpm_audio(start_bpm)

	# Apply circle animation for this BPM (show only if toggle allows)
	apply_moving_circle_for_bpm(start_bpm)

	# Spawn first bar only for non-challenge modes.
	# For challenge mode, play_countdown() already spawns the first bar.
	if mode != "challenge":
		spawn_current_bar()

	# Connect beat signal once
	if metronome.has_signal("beat_tick"):
		# Use Callable so disconnect/connect consistent if reloaded
		if not metronome.is_connected("beat_tick", Callable(self, "_on_tick")):
			metronome.connect("beat_tick", Callable(self, "_on_tick"))

	# Pad inputs
	left_pad.connect("input_event", Callable(self, "_on_left_pad_input"))
	right_pad.connect("input_event", Callable(self, "_on_right_pad_input"))


# -----------------------
func play_countdown(bpm: int) -> void:
	in_countdown = true
	touchpad_container.set_enabled(false)


	# Pause/hide circle during countdown
	if animation_player:
		animation_player.stop()
	if show_moving_circle_in_challenge or mode == "practice":
		moving_circle.hide()

	# 🔹 Hide notes only in challenge mode
	if mode == "challenge":
		clear_notes()

	countdown_label.visible = true

	var beat_duration = 60.0 / float(bpm)  # seconds per beat
	var countdown_values = ["3", "2", "1", "GO"]
	for value in countdown_values:
		countdown_label.text = value
		countdown_audio_player.play()
		await get_tree().create_timer(beat_duration).timeout

	countdown_label.visible = false

	# Show circle back (if allowed) after countdown
	if show_moving_circle_in_challenge or mode == "practice":
		moving_circle.show()

	in_countdown = false
	touchpad_container.set_enabled(true)


	# 🔹 After countdown, spawn the first notes for challenge
	if mode == "challenge":
		# ensure index is set to 0 and spawn first bar
		current_bar_index = 0
		tick_counter = 0
		spawn_current_bar()


# -----------------------
func spawn_current_bar():
	clear_notes()

	var total_continue_bars = drum_module.continue_bars.size()
	var bar_data: Resource = null

	# Determine which bar to show
	if current_bar_index < total_continue_bars:
		# Continue bar
		bar_data = drum_module.continue_bars[current_bar_index]
		hitline_sprite.texture = con_texture
		hitline_sprite.position = bar_offsets["continue"]

	elif current_bar_index == total_continue_bars:
		# End bar
		bar_data = drum_module.end_bar
		hitline_sprite.texture = end_texture
		hitline_sprite.position = bar_offsets["end"]

	else:
		# Beyond last bar
		if mode == "practice":
			current_bar_index = 0
			bar_data = drum_module.continue_bars[current_bar_index]
			hitline_sprite.texture = con_texture
			hitline_sprite.position = bar_offsets["continue"]
		else:
			# Challenge Mode → finished all bars, switch BPM or end
			switch_or_finish()
			return

	# Spawn notes for this bar
	if bar_data:
		spawn_notes_from_bar(bar_data)

	# ✅ Start moving circle + play audio for this bar
	var bpm_now: int = bpm_sequence[current_bpm_index]
	apply_moving_circle_for_bpm(bpm_now)
	play_bpm_audio(bpm_now)



# -----------------------
func spawn_notes_from_bar(bar_data):
	for note_data in bar_data.notes:
		if note_data and note_data.note_scene:
			var note = note_data.note_scene.instantiate()
			note.position = Vector2(note_data.x_position, 415)
			note.set_meta("drum_note_resource", note_data)
			add_child(note)
			notes.append(note)

			# NOTE: removed counting here to avoid double-counting
			# total_notes is computed once at start for challenge mode


# -----------------------
func clear_notes():
	for note in notes:
		note.queue_free()
	notes.clear()

func _process(delta: float) -> void:
	if mode != "practice" and not challenge_mode_has_ended:
		for note in notes:
			var beams = note.get_node("BeamContainer").get_children()
			for beam in beams:
				if beam is Area2D and not beam.has_meta("hit") and not beam.has_meta("missed"):
					var beam_x = beam.global_position.x
					var circle_x = moving_circle.global_position.x
					# Check if the moving circle has passed the hit area
					if circle_x > beam_x + hit_radius:
						beam.set_meta("missed", true)
						on_miss()

func on_miss():
	total_misses += 1

func on_manual_miss():
	total_misses += 1
	play_miss_effect()

# -----------------------
func _on_tick() -> void:
	if challenge_mode_has_ended or in_countdown:
		return

	tick_counter += 1

	# When a full bar passes (4 beats)
	if tick_counter >= beats_to_cover:
		tick_counter = 0
		current_bar_index += 1

		# Spawn the next bar (audio and circle start here)
		spawn_current_bar()


# -----------------------
func switch_or_finish():
	if current_bpm_index + 1 < bpm_sequence.size():
		# More BPMs left → switch
		await switch_to_next_bpm()
	else:
		# No more BPMs → end challenge
		end_challenge_mode()



# -----------------------
func switch_to_next_bpm():
	current_bpm_index += 1
	if current_bpm_index < bpm_sequence.size():
		var new_bpm: int = bpm_sequence[current_bpm_index]
		print("🔹 Switching to BPM:", new_bpm)

		update_bpm_menu_display(new_bpm)  # 🔹 update MenuButton label

		# Reset values for new BPM: next spawn is done by play_countdown()
		current_bar_index = 0
		tick_counter = 0

		# Stop old audio and metronome before countdown to avoid overlap
		bpm_audio.stop()
		bars_played = 0
		metronome.stop()

		# Countdown (circle hidden & ticks gated) -> play_countdown will spawn first bar
		await play_countdown(new_bpm)

		# Update duration for 4 beats at this BPM
		moving_circle_duration = (60.0 / float(new_bpm)) * beats_to_cover

		# Restart metronome timer at the new BPM (silent, only timing)
		metronome.start(new_bpm, mode)

		# ⬇️ Reset tick counter after restart
		tick_counter = 0

		# Play the correct BPM audio file
		play_bpm_audio(new_bpm)

		# Apply BPM-specific moving circle animation (respect toggle)
		apply_moving_circle_for_bpm(new_bpm)

		# NOTE: do NOT call spawn_current_bar() here. play_countdown() already did.
	else:
		end_challenge_mode()


# -----------------------
func end_challenge_mode():
	# 🔹 Stop all sounds
	bpm_audio.stop()
	metronome.stop()

	challenge_mode_has_ended = true

	# 🚫 Disable all pad input when challenge ends
	touchpad_container.set_enabled(false)
	left_pad.set_process_input(false)
	right_pad.set_process_input(false)

	await get_tree().process_frame


	if metronome.has_node("TickSound"):
		var tick_sound = metronome.get_node("TickSound")
		if tick_sound is AudioStreamPlayer:
			tick_sound.stop()

	if animation_player:
		animation_player.stop()
	moving_circle.visible = false
	clear_notes()

	await get_tree().create_timer(2.0).timeout

	var hit_percentage: float = 0.0
	var total_attempts := total_hits + total_misses
	if total_attempts > 0:
		hit_percentage = float(total_hits) / float(total_attempts) * 100.0

	if hit_percentage >= 95:
		grade = "S"
	elif hit_percentage >= 85:
		grade = "A"
	elif hit_percentage >= 70:
		grade = "B"
	elif hit_percentage >= 50:
		grade = "C"
	else:
		grade = "Failed"

	print("Challenge Results:")
	print("Hits: %d / %d" % [total_hits, total_notes])
	print("Misses: %d" % total_misses)
	print("Hit %%: %.1f%%" % hit_percentage)
	print("Grade: %s" % grade)
	module_score(grade)
	print("Module Grades :" , GameState.module_grades)

	if has_node("PassSound") and has_node("FailSound"):
		if grade != "Failed":
			get_node("PassSound").play()
			$PassInstrumental.play()
		else:
			get_node("FailSound").play()

	_show_results(hit_percentage, grade)


# -----------------------
func _unhandled_input(event: InputEvent) -> void:
	if in_countdown or challenge_mode_has_ended: # 🚫 Ignore all inputs during countdown
		return

	if event is InputEventScreenTouch and event.pressed:
		var pos = event.position

		var left_collider = left_pad.get_node("CollisionShape2D")
		var right_collider = right_pad.get_node("CollisionShape2D")

		if left_collider and point_inside_shape(left_collider, pos):
			animate_pad(left_pad)
			check_hit("left")
		elif right_collider and point_inside_shape(right_collider, pos):
			animate_pad(right_pad)
			check_hit("right")

	elif event.is_action_pressed("left_pad"):
		animate_pad(left_pad)
		check_hit("left")
	elif event.is_action_pressed("right_pad"):
		animate_pad(right_pad)
		check_hit("right")


# -----------------------
func _on_left_pad_input(_viewport, event, _shape_idx):
	if in_countdown or challenge_mode_has_ended: # 🚫 Ignore pad during countdown
		return
	if event is InputEventMouseButton and event.pressed:
		animate_pad(left_pad)
		check_hit("left")


func _on_right_pad_input(_viewport, event, _shape_idx):
	if in_countdown or challenge_mode_has_ended: # 🚫 Ignore pad during countdown
		return
	if event is InputEventMouseButton and event.pressed:
		animate_pad(right_pad)
		check_hit("right")


# -----------------------
func animate_pad(pad: Node2D) -> void:
	var original_scale = pad.scale
	pad.scale = original_scale * 0.9
	if pad.has_node("HitSound"):
		var hit_sound = pad.get_node("HitSound")
		if hit_sound is AudioStreamPlayer2D:
			hit_sound.play()
	await get_tree().create_timer(0.1).timeout
	pad.scale = original_scale


# -----------------------
func check_hit(pad_side: String) -> void:
	for note in notes:
		var beams = note.get_node("BeamContainer").get_children()
		for beam in beams:
			# 🔹 Use the beam's required_pad instead of note meta
			if not (beam.has_method("is_beam") and beam.is_beam()):
				continue

			var required_pad = beam.required_pad

			# Skip if this beam doesn't match the pressed pad
			if required_pad != "both" and required_pad != pad_side:
				continue

			# Check if this beam is already hit
			if not beam.has_meta("hit"):
				var beam_x = beam.global_position.x
				var circle_x = moving_circle.global_position.x
				if abs(beam_x - circle_x) < hit_radius:
					beam.set_meta("hit", true)
					if beam.has_method("register_hit"):
						beam.register_hit()
					play_hit_effect(beam.global_position)
					total_hits += 1
					return
	play_miss_effect()


# -----------------------
func play_miss_effect() -> void:
	total_misses += 1
	var miss = miss_effect_scene.instantiate()
	effects_container.add_child(miss)
	miss.position = effects_container.to_local(moving_circle.global_position)
	miss.scale = Vector2(0.5, 0.5)
	miss.z_index = 10
	await get_tree().create_timer(0.5).timeout
	miss.queue_free()


# -----------------------
func play_hit_effect(effect_position: Vector2) -> void:
	var hit = hit_effect_scene.instantiate()
	effects_container.add_child(hit)
	hit.position = effects_container.to_local(effect_position)
	hit.scale = Vector2(0.5, 0.5)
	hit.z_index = 10
	await get_tree().create_timer(0.2).timeout
	hit.queue_free()


# -----------------------
func point_inside_shape(collider: CollisionShape2D, global_point: Vector2) -> bool:
	var shape = collider.shape
	if shape == null:
		return false

	var local_point = collider.to_local(global_point)

	if shape is RectangleShape2D:
		var half_extents = shape.extents
		return abs(local_point.x) <= half_extents.x and abs(local_point.y) <= half_extents.y
	elif shape is CircleShape2D:
		return local_point.length() <= shape.radius
	else:
		return false


# -----------------------
func update_bpm_menu_display(new_bpm: int) -> void:
	if bpm_menu_button:
		bpm_menu_button.text = "BPM: %d" % new_bpm


# -----------------------
func play_bpm_audio(bpm: int) -> void:
	if not BPM_AUDIO_PATHS.has(bpm):
		print("No BPM audio path for", bpm)
		return

	var stream = load(BPM_AUDIO_PATHS[bpm])
	if not stream:
		print("Failed to load BPM audio:", BPM_AUDIO_PATHS[bpm])
		return

	bpm_audio.stop()
	bpm_audio.stream = stream
	bpm_audio.play()


func _on_bpm_audio_finished() -> void:
	if challenge_mode_has_ended or in_countdown:
		return

	var is_end_bar = bpm_audio.has_meta("is_end_bar") and bpm_audio.get_meta("is_end_bar")

	if mode == "practice":
		# Practice Mode: repeat audio for bars_per_bpm times
		bars_played += 1
		if bars_played < bars_per_bpm:
			bpm_audio.play()
		else:
			bars_played = 0

	else:
		# Challenge Mode
		if is_end_bar:
			# Last bar for this BPM finished → go to next BPM
			switch_or_finish()
		else:
			# Move to next continue bar
			current_bar_index += 1
			spawn_current_bar()


# -----------------------
func spawn_next_bar() -> void:
	current_bar_index += 1
	var total_continue = drum_module.continue_bars.size()
	var total_bars = total_continue + 1  # +1 for end bar

	if current_bar_index < total_bars:
		# Spawn the next bar
		spawn_current_bar()
		# Play BPM audio again for the new bar
		var bpm_now: int = bpm_sequence[current_bpm_index]
		play_bpm_audio(bpm_now)
	else:
		# Finished all bars → go to next BPM
		switch_or_finish()



# -----------------------
# Play moving circle animation for this BPM
func apply_moving_circle_for_bpm(bpm: int) -> void:
	# Choose animation based on BPM
	var anim_name: String
	match bpm:
		60:
			anim_name = "moving_circle"
		80:
			anim_name = "moving_circle_80"
		100:
			anim_name = "moving_circle_100"
		_:
			anim_name = "moving_circle"  # fallback for any other BPM

	# Show or hide circle depending on mode/toggle
	if show_moving_circle_in_challenge or mode == "practice":
		moving_circle.show()
	else:
		moving_circle.hide()

	# Check if the animation exists before playing
	if animation_player.has_animation(anim_name):
		var anim = animation_player.get_animation(anim_name)

		# Scale speed to match the length of the BPM audio
		if bpm_audio.stream:
			var audio_length = bpm_audio.stream.get_length()
			animation_player.speed_scale = anim.length / audio_length
		else:
			animation_player.speed_scale = 1.0

		animation_player.stop()
		animation_player.play(anim_name)
	else:
		print("⚠️ Warning: Animation not found:", anim_name)



# -----------------------
func on_bpm_label_selected(new_bpm: int) -> void:
	if mode != "practice":
		return

	bpm_audio.stop()
	metronome.stop()

	current_bar_index = 0
	tick_counter = 0

	await play_countdown(new_bpm)

	bpm_label.text = "BPM: %d" % new_bpm
	metronome.start(new_bpm, mode)

	play_bpm_audio(new_bpm)

	# 🔹 Restart circle with BPM-specific anim
	apply_moving_circle_for_bpm(new_bpm)

	spawn_current_bar()


# -----------------------
func update_bpm(new_bpm: int) -> void:
	if mode != "practice":
		return

	bpm_audio.stop()
	metronome.stop()

	current_bar_index = 0
	tick_counter = 0
	current_bpm_index = bpm_sequence.find(new_bpm)
	if current_bpm_index == -1:
		current_bpm_index = 0

	await play_countdown(new_bpm)

	update_bpm_menu_display(new_bpm)  # 🔹 update MenuButton label
	metronome.start(new_bpm, mode)
	play_bpm_audio(new_bpm)

	# Restart moving circle animation for this BPM
	apply_moving_circle_for_bpm(new_bpm)

	spawn_current_bar()


# -----------------------
func _on_back_pressed() -> void:
	GlobalAudio.mute_bgm(false)
	GlobalAudio.play_click()
	get_tree().change_scene_to_file("res://Sample/sample_scene.tscn")


# -----------------------
func _show_results(passed_hit_percentage: float, passed_grade: String):
	var results_scene = preload("res://Sample/result_scene.tscn").instantiate()
	results_scene.total_hits = total_hits
	results_scene.total_notes = total_notes
	results_scene.total_misses = total_misses
	results_scene.hit_percentage = passed_hit_percentage
	results_scene.grade = passed_grade
	results_scene.mode = mode  # Pass the mode to the results scene

	get_tree().get_root().add_child(results_scene)
	hide()


# -----------------------
# --- New helper: count beams in the module once
func compute_total_notes_from_module() -> int:
	var count := 0

	# Count beams in each continue bar
	for bar in drum_module.continue_bars:
		for note_data in bar.notes:
			if note_data and note_data.note_scene:
				var temp_note = note_data.note_scene.instantiate()
				var beams = temp_note.get_node("BeamContainer").get_children()
				for beam in beams:
					if beam.has_method("is_beam") and beam.is_beam():
						count += 1
				temp_note.queue_free()

	# Count beams in end bar (if present)
	if drum_module.end_bar:
		for note_data in drum_module.end_bar.notes:
			if note_data and note_data.note_scene:
				var temp_note = note_data.note_scene.instantiate()
				var beams = temp_note.get_node("BeamContainer").get_children()
				for beam in beams:
					if beam.has_method("is_beam") and beam.is_beam():
						count += 1
				temp_note.queue_free()

	return count

#this is for storing the grades of each level
func module_score(final_grade_string: String):
	var lessons_index = GameState.lessons - 1
	var grade_ranking = {"S": 5, "A": 4, "B": 3, "C": 2, "Failed": 1, "N/A": 0}

	if lessons_index >= 0 and lessons_index < GameState.module_grades.size():
		var existing_grade = GameState.module_grades[lessons_index]
		var existing_rank = grade_ranking.get(existing_grade, 0)
		var new_rank = grade_ranking.get(final_grade_string, 0)

		if new_rank > existing_rank:
			GameState.module_grades[lessons_index] = final_grade_string
			
			
# --------------------------------------------------------
# DEBUG: print moving circle position at specific times
func debug_circle_positions(bpm: int) -> void:
	var checkpoints := []
	
	# define checkpoints depending on bpm
	match bpm:
		60:
			checkpoints = [0.0, 1.0, 2.0, 3.0, 4.0]
		80:
			checkpoints = [0.0, 0.75, 1.5, 2.25, 3.0]
		100:
			checkpoints = [0.0, 0.60, 1.2, 1.8, 2.4]

	# run timers for each checkpoint
	for t in checkpoints:
		await get_tree().create_timer(t).timeout
		var pos_x = moving_circle.global_position.x
		print("⏱️ BPM:", bpm, " | Time:", t, "sec | Circle X:", pos_x)


func transition_anim():
	$animation_transition.show()
	$animation_transition/AnimationPlayer.play("Transition")
	await $animation_transition/AnimationPlayer.animation_finished
	$animation_transition.queue_free()
	$Back.show()
	$HitLine.show()
	$Metronome.show()
	$BPMMenuButton.show()
	$TouchPadContainer.show()
	$MovingCircle.show()
