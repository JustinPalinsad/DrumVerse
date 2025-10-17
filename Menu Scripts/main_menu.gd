extends Control

@onready var anim_player = $"Selection Container/Selection Animation"

const STEP := 0.3
const MIN_INDEX := 0
const MAX_INDEX := 2

var target_time := 0.0
var is_animating := false
var animation_direction := 1
var input_locked := false
var changing_scene := false
var scene_just_loaded := true # 💡 STILL NEEDED: Flag to debounce input on load

# Swipe detection
var swipe_start_pos: Vector2
var swipe_threshold: float = 100.0 # minimum swipe distance

func _ready():
	GameState.sample_selection_anim_has_played = false
	GameState.notes_section_anim_has_played =false
	GameState.notes_index = 0
	# Ensure GameState.main_menu_index exists
	_update_menu_position()
	
	# 💡 REFINED FIX: Increase the debounce timer to 0.1 seconds.
	# This gives the system more time to flush any immediate, residual input events 
	# (like a touch-release event from the scene change).
	await get_tree().create_timer(0.1).timeout 
	scene_just_loaded = false


# -----------------------------
# Public function to change index (buttons, swipe, keyboard)
# -----------------------------
func change_index(direction: int) -> void:
	# 💡 REFINED CHECK: Check if the scene just loaded
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

# -----------------------------
# Swipe and keyboard input
# -----------------------------
func _input(event: InputEvent) -> void:
	# 💡 REFINED CHECK: Check scene_just_loaded here
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
