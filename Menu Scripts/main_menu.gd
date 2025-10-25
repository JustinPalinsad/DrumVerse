extends Control

@onready var anim_player = $"Selection Container/Selection Animation"
@onready var tutorial_mode_scene = preload("res://Menu Scenes/tutorial_mode.tscn") # 💡 ADDED: Tutorial scene preload

const STEP := 0.3
const MIN_INDEX := 0
const MAX_INDEX := 2

var target_time := 0.0
var is_animating := false
var animation_direction := 1
var input_locked := false
var changing_scene := false
var scene_just_loaded := true # Flag to debounce input on load

# Swipe detection
var swipe_start_pos: Vector2
var swipe_threshold: float = 100.0 # minimum swipe distance

func _ready():
	# 💡 CONSOLIDATED: GameState resets from old script
	GameState.sample_selection_anim_has_played = false
	GameState.notes_section_anim_has_played = false
	GameState.notes_index = 0
	
	_update_menu_position()
	
	# 🧠 TUTORIAL LOGIC: Only show tutorial when first_time_play is true
	if GameState.first_time_play:
		input_locked = true
		show_tutorial_mode() # call the tutorial scene here
	else:
		# 💡 DEBOUNCE FIX: Only run the debounce timer if the tutorial ISN'T showing,
		# otherwise, the tutorial finish handler unlocks input.
		_apply_load_debounce()

# 💡 NEW/MODIFIED: Helper for the debounce timer
func _apply_load_debounce() -> void:
	# Increase the debounce timer to 0.1 seconds.
	get_tree().create_timer(0.1).timeout.connect(Callable(self, "_on_debounce_finished"))

func _on_debounce_finished() -> void:
	scene_just_loaded = false


# -----------------------------
# TUTORIAL FUNCTIONS
# -----------------------------
func show_tutorial_mode() -> void:
	TutorialManager.start_tutorial()

	# Wait until tutorial finishes (tree_exited signal)
	if TutorialManager.tutorial_instance:
		# Use the simplified connect syntax for Godot 4
		TutorialManager.tutorial_instance.tree_exited.connect(_on_tutorial_finished)


func _on_tutorial_finished() -> void:
	GameState.first_time_play = false # 🔁 remember that tutorial is done
	input_locked = false
	# Once tutorial finishes, apply the debounce to prevent post-tutorial swipe input
	_apply_load_debounce()

# -----------------------------
# Public function to change index (buttons, swipe, keyboard)
# -----------------------------
func change_index(direction: int) -> void:
	# Check if the scene just loaded OR if tutorial is active
	if input_locked or is_animating or changing_scene or scene_just_loaded:
		return
	var new_index = clamp(GameState.main_menu_index + direction, MIN_INDEX, MAX_INDEX)
	if new_index != GameState.main_menu_index:
		GameState.main_menu_index = new_index
		if $ClickSoundPlayer:
			$ClickSoundPlayer.play()
		_play_to_index(new_index)

# -----------------------------
# Animation
# -----------------------------
func _play_to_index(index: int):
	if not anim_player:
		return
	target_time = clamp(index * STEP, 0.0, anim_player.current_animation_length - 0.001)
	var current_time = anim_player.current_animation_position
	if is_equal_approx(current_time, target_time):
		return
	animation_direction = sign(target_time - current_time)
	anim_player.play("menu_animation")
	anim_player.speed_scale = animation_direction
	is_animating = true

func _process(_delta):
	if changing_scene:
		return # prevent animations from running after scene change

	if is_animating:
		if not anim_player:
			return
		var current_time = anim_player.current_animation_position
		if (animation_direction > 0 and current_time >= target_time) or \
		   (animation_direction < 0 and current_time <= target_time):
			anim_player.seek(target_time, true)
			anim_player.pause()
			is_animating = false
	else:
		_sync_with_game_state()

func _sync_with_game_state():
	if not anim_player:
		return
	var expected_time = GameState.main_menu_index * STEP
	if not is_equal_approx(anim_player.current_animation_position, expected_time):
		anim_player.seek(expected_time, true)
		anim_player.pause()

func _update_menu_position():
	if not anim_player:
		return
	var index = GameState.main_menu_index
	anim_player.play("menu_animation")
	anim_player.seek(float(index) * STEP, true) 
	anim_player.pause()


# -----------------------------
# Button handlers
# -----------------------------
func _on_left_b_pressed() -> void:
	change_index(-1)

func _on_right_b_pressed() -> void:
	change_index(1)

func _on_left_button_pressed() -> void:
	change_index(-1)

func _on_right_button_pressed() -> void:
	change_index(1)

func _on_select_button_pressed() -> void:
	if input_locked or changing_scene:
		return
	GlobalAudio.play_click()
	changing_scene = true
	input_locked = true
	if anim_player:
		anim_player.stop()

	match GameState.main_menu_index:
		0: get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
		1: get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
		2: get_tree().change_scene_to_file("res://Menu Scenes/settings_scene.tscn")

func _on_back_pressed() -> void:
	if input_locked or changing_scene:
		return
	$BackSoundPlayer.play()
	changing_scene = true
	input_locked = true
	if anim_player:
		anim_player.stop()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/title_screen.tscn")

# 💡 NEW: Button for manually starting the tutorial
func _on_qmark_butt_pressed() -> void:
	if input_locked:
		return
	show_tutorial_mode()
	input_locked = true
	# Lock input, tutorial_finished handler will unlock it.

# -----------------------------
# Swipe and keyboard input
# -----------------------------
func _input(event: InputEvent) -> void:
	# Check scene_just_loaded here
	if input_locked or is_animating or changing_scene or scene_just_loaded:
		return

	# Keyboard arrows
	if event.is_action_pressed("ui_right"):
		change_index(1)
	elif event.is_action_pressed("ui_left"):
		change_index(-1)

	# Touchscreen swipes
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start_pos = event.position
		else:
			var swipe_vector = event.position - swipe_start_pos
			if abs(swipe_vector.x) > swipe_threshold and abs(swipe_vector.x) > abs(swipe_vector.y):
				if swipe_vector.x > 0:
					change_index(-1) # swipe right means move LEFT in index (e.g., from 2 to 1)
				else:
					change_index(1) # swipe left means move RIGHT in index (e.g., from 1 to 2)
