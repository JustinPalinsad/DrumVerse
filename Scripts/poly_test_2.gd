extends Control

signal tap_detected # Custom signal to reliably detect a tap/click

var HitScene := preload("res://Scenes/Shared/HitEffect.tscn")
var MissScene := preload("res://Scenes/Shared/MissEffect.tscn")

# keep track of the note/area currently inside each hitbox
var top_target: Area2D = null
var bottom_target: Area2D = null

# counters
var top_play_count: int = 0
var bottom_play_count: int = 0
var demo_play_count: int = 0
var max_plays: int = 4

# --- scoring ---
var total_hits: int = 0
var total_misses: int = 0
var total_attempts: int = 0


var bpm_animations = [
	{"top": "Top_Line", "bottom": "Bottom_Line"},           # 60
	{"top": "Top_Line_80", "bottom": "Bottom_Line_80"},       # 80
	{"top": "Top_Line_100", "bottom": "Bottom_Line_100"}      # 100
]

var current_bpm_index := 0

# references for readability
@onready var top_anim = $Middle_Point/HitLineTop/MovingCircleTop/TopBallAnim
@onready var bottom_anim = $Middle_Point/HitLineBottom/MovingCircleBottom/BottomBallAnim
@onready var countdown_label: Label = $CountdownLabel     # 👈 Label node for countdown

# --- INPUT FUNCTION FOR TAP DETECTION ---
func _input(event: InputEvent) -> void:
	# Emit the signal when the user presses the left mouse button (for tap/click)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		tap_detected.emit()
	# Also check "ui_accept" action (usually Space/Enter/Tap on mobile)
	elif event.is_action_pressed("ui_accept"):
		tap_detected.emit()

func _ready() -> void:
	GlobalAudio.mute_bgm(true)
	if GameState.polyrhythm_mode == "learning":
		learning_mode()
		# In learning_mode(), Demo Vid and TutorialHolder are shown, Middle_Point is hidden.
	elif GameState.polyrhythm_mode == "practice":
		_start_practice_countdown()
	else:
		$Middle_Point/HitLineTop/MovingCircleTop.hide()
		$Middle_Point/HitLineBottom/MovingCircleBottom.hide()
		# If not learning mode (i.e., practice or challenge):
		
		# 1. DISABLE/HIDE Demo Vid
		$"Demo Vid".hide()
		$"Demo Vid".position.x = 2616.0
		
		# 2. Setup the game scene
		$TutorialHolder.hide()
		$Middle_Point.show()
		$TouchPadContainer.show()
		
		# hide animations until countdown is done
		top_anim.stop()
		bottom_anim.stop()

		# connect hitbox signals
		$Middle_Point/HitLineTop/MovingCircleTop/HitArea.area_entered.connect(_on_top_area_entered)
		$Middle_Point/HitLineTop/MovingCircleTop/HitArea.area_exited.connect(_on_top_area_exited)
		$Middle_Point/HitLineBottom/MovingCircleBottom/HitArea.area_entered.connect(_on_bottom_area_entered)
		$Middle_Point/HitLineBottom/MovingCircleBottom/HitArea.area_exited.connect(_on_bottom_area_exited)

		# start countdown before game
		_start_countdown()
# --- COUNTDOWN ---
# -----------------------------
# Challenge Countdown
# -----------------------------
func _start_countdown() -> void:
	countdown_label.visible = true

	var numbers = ["3", "2", "1", "Go!"]
	for n in numbers:
		countdown_label.text = n
		$CountdownAudioPlayer.play()
		await get_tree().create_timer(1.0).timeout

	countdown_label.visible = false

	top_play_count = 0
	bottom_play_count = 0

	await _play_bpm_stage()

# -----------------------------
# Practice Countdown
# -----------------------------
func _start_practice_countdown() -> void:
	countdown_label.visible = true

	var numbers = ["3", "2", "1", "Go!"]
	for n in numbers:
		countdown_label.text = n
		$CountdownAudioPlayer.play()
		await get_tree().create_timer(1.0).timeout

	countdown_label.visible = false

	_play_practice_animation()


# -----------------------------
# Challenge Mode → 4 synced plays
# -----------------------------
func _play_bpm_stage() -> void:
	var top_name = bpm_animations[current_bpm_index]["top"]
	var bottom_name = bpm_animations[current_bpm_index]["bottom"]

	for i in range(max_plays):
		top_play_count = i + 1
		bottom_play_count = i + 1
#
		#top_anim.loop = false
		#bottom_anim.loop = false

		top_anim.play(top_name)
		bottom_anim.play(bottom_name)

		await top_anim.animation_finished
		await bottom_anim.animation_finished

	_next_bpm_stage()

# -----------------------------
# Practice Mode → Loop forever
# -----------------------------
func _play_practice_animation() -> void:
	var top_name = bpm_animations[current_bpm_index]["top"]
	var bottom_name = bpm_animations[current_bpm_index]["bottom"]

	while true:
		top_anim.play(top_name)
		bottom_anim.play(bottom_name)

		# Wait until both finish
		await top_anim.animation_finished
		await bottom_anim.animation_finished





# --- ANIMATION PLAY LIMIT ---
func _play_top_animation() -> void:
	var anim_name = bpm_animations[current_bpm_index]["top"]

	if GameState.polyrhythm_mode == "practice":
		top_anim.play(anim_name)
		await top_anim.animation_finished
		_play_top_animation()
		return

	if top_play_count < max_plays:
		top_play_count += 1
		top_anim.play(anim_name)
		await top_anim.animation_finished
		_play_top_animation()
	else:
		_check_bpm_complete()



func _play_bottom_animation() -> void:
	var anim_name = bpm_animations[current_bpm_index]["bottom"]

	if GameState.polyrhythm_mode == "practice":
		bottom_anim.play(anim_name)
		await bottom_anim.animation_finished
		_play_bottom_animation()
		return

	if bottom_play_count < max_plays:
		bottom_play_count += 1
		bottom_anim.play(anim_name)
		await bottom_anim.animation_finished
		_play_bottom_animation()
	else:
		_check_bpm_complete()

func _check_bpm_complete() -> void:
	# Only move to next BPM when BOTH are done
	if top_play_count >= max_plays and bottom_play_count >= max_plays:
		_next_bpm_stage()


func _next_bpm_stage() -> void:
	current_bpm_index += 1

	# When 60 → 80 → 100 finished
	if current_bpm_index >= bpm_animations.size():
		_check_results()
		return

	# Stop animations cleanly and rewind
	top_anim.stop(true)
	bottom_anim.stop(true)

	await get_tree().create_timer(0.5).timeout

	# Restart countdown for next BPM animation set
	_start_countdown()


# --- TOP HITBOX ---
func _on_top_area_entered(area: Area2D) -> void:
	top_target = area
	area.set_meta("was_hit", false)
	area.set_meta("enter_time", Time.get_ticks_msec())  # 👈 track when it entered


func _on_top_area_exited(area: Area2D) -> void:
	if top_target == area:
		var stay_time = Time.get_ticks_msec() - int(area.get_meta("enter_time"))

		# only count as miss if it stayed long enough and wasn't hit
		if stay_time > 100 and not area.get_meta("was_hit"):
			total_attempts += 1
			total_misses += 1
			print("TOP MISS (passed without hit)")
			# 👇 no spawn miss effect here anymore

		top_target = null


# --- BOTTOM HITBOX ---
func _on_bottom_area_entered(area: Area2D) -> void:
	bottom_target = area
	area.set_meta("was_hit", false)
	area.set_meta("enter_time", Time.get_ticks_msec())


func _on_bottom_area_exited(area: Area2D) -> void:
	if bottom_target == area:
		var stay_time = Time.get_ticks_msec() - int(area.get_meta("enter_time"))

		if stay_time > 100 and not area.get_meta("was_hit"):
			total_attempts += 1
			total_misses += 1
			print("BOTTOM MISS (passed without hit)")
			# 👇 no spawn miss effect here either

		bottom_target = null



# --- HELPER: activate after 1 frame ---
func _activate_note(area: Area2D) -> void:
	if is_instance_valid(area):
		area.set_meta("active", true)



func _process(delta: float) -> void:
	# check top (left_pad)
	if Input.is_action_just_pressed("left_pad"):
		total_attempts += 1
		if top_target:
			print("TOP HIT")
			total_hits += 1
			top_target.set_meta("was_hit", true)
			_spawn_hit_effect(top_target)
		else:
			print("TOP MISS (pressed outside)")
			total_misses += 1
			_spawn_miss_effect($Middle_Point/HitLineTop/MovingCircleTop/HitArea)

	if Input.is_action_just_pressed("right_pad"):
		total_attempts += 1
		if bottom_target:
			print("BOTTOM HIT")
			total_hits += 1
			bottom_target.set_meta("was_hit", true)
			_spawn_hit_effect(bottom_target)
		else:
			print("BOTTOM MISS (pressed outside)")
			total_misses += 1
			_spawn_miss_effect($Middle_Point/HitLineBottom/MovingCircleBottom/HitArea)



# --- EFFECTS ---
func _spawn_hit_effect(target: Node) -> void:
	var hit_instance = HitScene.instantiate()
	add_child(hit_instance)

	hit_instance.global_position = target.global_position
	hit_instance.z_index = 10

	# force 0.5 scale
	if hit_instance is Node2D:
		hit_instance.scale = Vector2(0.5, 0.5)
	elif hit_instance is Control:
		hit_instance.rect_scale = Vector2(0.5, 0.5)

	hit_instance.get_tree().create_timer(0.2).timeout.connect(
		func():
			if is_instance_valid(hit_instance):
				hit_instance.queue_free()
	)


func _spawn_miss_effect(area_node: Node) -> void:
	var miss_instance = MissScene.instantiate()
	add_child(miss_instance)

	miss_instance.global_position = area_node.global_position
	miss_instance.z_index = 10

	# force 0.5 scale
	if miss_instance is Node2D:
		miss_instance.scale = Vector2(0.5, 0.5)
	elif miss_instance is Control:
		miss_instance.rect_scale = Vector2(0.5, 0.5)

	miss_instance.get_tree().create_timer(0.2).timeout.connect(
		func():
			if is_instance_valid(miss_instance):
				miss_instance.queue_free()
	)


# --- RESULTS CALCULATION ---
func _check_results() -> void:
	# Only show results once both top and bottom are done
	if top_play_count >= max_plays and bottom_play_count >= max_plays:
		var hit_percentage: float = 0.0
		if total_attempts > 0:
			hit_percentage = float(total_hits) / float(total_attempts) * 100.0

		var grade: String = ""
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

		print("Results -> Hits:", total_hits, " Misses:", total_misses, 
			  " Attempts:", total_attempts, " Percentage:", hit_percentage, " Grade:", grade)

		_show_results(hit_percentage, grade)


# --- SHOW RESULTS SCENE ---
func _show_results(passed_hit_percentage: float, passed_grade: String):
	var results_scene = preload("res://Sample/result_scene.tscn").instantiate()
	Results.total_hits = total_hits
	Results.total_notes = total_attempts
	Results.total_misses = total_misses
	Results.hit_percentage = passed_hit_percentage
	Results.grade = passed_grade
	Results.mode = "default"

	get_tree().change_scene_to_file("res://Sample/polyrhythm_result_scene.tscn")


func _on_back_pressed() -> void:
	GlobalAudio.mute_bgm(false)
	GlobalAudio.play_click()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Sample/sample_scene.tscn")

func learning_mode():
	$"Demo Vid".show()
	$Middle_Point.hide()
	$TutorialHolder.show()
	$TouchPadContainer.hide()
	
	# Hide any lingering TryAgain or Replay buttons at the start
	if has_node("TryAgain"):
		$TryAgain.hide()
	$ReplayButton.hide()
	
	var children = $TutorialHolder.get_children()

	# Hide all labels first
	for child in children:
		if child is Label:
			child.visible = false

	# Show labels one by one when the user taps/clicks
	for i in range(children.size()):
		if children[i] is Label:
			# Hide the previous label (if any)
			if i > 0 and children[i - 1] is Label:
				children[i - 1].visible = false

			# Show current label
			children[i].visible = true

			# Wait until user taps once
			await _wait_for_tap()

	# After the sequence, hide the last label
	if children.size() > 0 and children[-1] is Label:
		children[-1].visible = false

	# Play the animation until it reaches max_plays
	while demo_play_count < max_plays:
		demo_play_count += 1
		print("Playing Demo Animation (Loop ", demo_play_count, " of ", max_plays, ")")
		
		# Play the animation
		$"Demo Vid/AnimationPlayer".play("Animation")
		
		# Wait for the animation to finish before looping again
		await $"Demo Vid/AnimationPlayer".animation_finished
	
	print("Demo animation finished.")
	
	# --- LOGIC FOR TAP/REPLAY/TRYAGAIN ---
	
	# We use a temporary timer and await _wait_for_tap() at the same time.
	# We don't need a timer here; we'll rely only on the tap to decide if 'TryAgain' shows.
	
	# 1. Show the Replay button first.
	$ReplayButton.show()
	
	# 2. Wait for a tap. If a tap occurs, it means the user tapped the screen instead of the button.
	await _wait_for_tap()

	# 3. If the code reaches here, a tap occurred. The ReplayButton was ignored.
	$"Demo Vid".hide()
	$ReplayButton.hide()
	
	# Only show $TryAgain if it exists
	if has_node("TryAgain"):
		$TryAgain.show()


# --- HELPER: Wait for a single tap (FIXED) ---
func _wait_for_tap() -> void:
	# Await the custom signal that is emitted when the user taps/clicks in _input()
	await tap_detected


func _on_replay_button_pressed() -> void:
	# If the user pressed the replay button, reset and restart
	$ReplayButton.hide()
	if has_node("TryAgain"):
		$TryAgain.hide()
	demo_play_count = 0
	learning_mode()
