extends Control

@onready var anim_player = $"Selection Container/Selection Animation"
@onready var tutorial_mode = preload("res://Menu Scenes/tutorial_mode.tscn")

const STEP := 0.3  # time step between button states

var target_time := 0.0
var is_animating := false
var animation_direction := 1  # 1 for forward, -1 for backward
var input_locked := false  # only locked during tutorial

func _ready():
	_update_menu_position()

	if GameState.first_time_play == true:
		input_locked = true  # ⛔ lock input only for first-time players
		await first_time_tutorial()
		input_locked = false  # ✅ unlock after tutorial ends

	GameState.sample_selection_anim_has_played = false
	GameState.notes_section_anim_has_played = false
	GameState.notes_index = 0

func _unhandled_input(event):
	if input_locked or is_animating:
		return  # Prevent input when locked or animating

	var current_index = GameState.main_menu_index

	if event.is_action_pressed("ui_right") and current_index < 2:
		$ClickSoundPlayer.play()
		await get_tree().create_timer(0.1).timeout
		GameState.main_menu_index += 1
		_play_to_index(GameState.main_menu_index)

	elif event.is_action_pressed("ui_left") and current_index > 0:
		$ClickSoundPlayer.play()
		await get_tree().create_timer(0.1).timeout
		GameState.main_menu_index -= 1
		_play_to_index(GameState.main_menu_index)

func _play_to_index(index: int):
	target_time = clamp(index * STEP, 0.0, anim_player.current_animation_length - 0.001)
	var current_time = anim_player.current_animation_position

	if is_equal_approx(current_time, target_time):
		return  # Already at correct time

	animation_direction = sign(target_time - current_time)
	anim_player.play("menu_animation")
	anim_player.speed_scale = animation_direction
	is_animating = true

func _process(_delta):
	if is_animating:
		var current_time = anim_player.current_animation_position
		if (animation_direction > 0 and current_time >= target_time) or \
		   (animation_direction < 0 and current_time <= target_time):
			anim_player.seek(target_time, true)
			anim_player.pause()
			is_animating = false
	else:
		_sync_with_game_state()

func _sync_with_game_state():
	var expected_time = GameState.main_menu_index * STEP
	if not is_equal_approx(anim_player.current_animation_position, expected_time):
		anim_player.seek(expected_time, true)
		anim_player.pause()

func _on_select_button_pressed() -> void:
	if input_locked:
		return
	GlobalAudio.play_click()

	match GameState.main_menu_index:
		0:
			get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
		1:
			get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
		2:
			get_tree().change_scene_to_file("res://Menu Scenes/settings_scene.tscn")

func _on_back_pressed() -> void:
	if input_locked:
		return
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/title_screen.tscn")

func _update_menu_position():
	var index = GameState.main_menu_index
	anim_player.play("menu_animation")
	anim_player.seek(index * STEP + 0.001, true)
	anim_player.pause()

# 🧩 Tutorial logic
func first_time_tutorial() -> void:
	var tutorial_mode_instance = tutorial_mode.instantiate()
	add_child(tutorial_mode_instance)

	# Wait for tutorial to close before unlocking input
	await tutorial_mode_instance.tree_exited
