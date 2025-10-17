extends CanvasLayer

var current_label_index := 0

func _ready() -> void:
	play_pop_up_anim()


func _on_yes_button_pressed() -> void:
	GlobalAudio.play_click()
	GameState.first_time_play = false
	GameState.main_menu_index = 1
	GameState.game_tutorial_active = true
	await play_pop_up_anim_reverse()

	if has_node("questionPanel"):
		$questionPanel.hide()
	if has_node("tutorialPanel"):
		$tutorialPanel.show()
		_hide_all_labels()
		_show_current_label()


func _on_no_button_pressed() -> void:
	GlobalAudio.play_click()
	GameState.first_time_play = true
	await play_pop_up_anim_reverse()
	_end_tutorial()


# --- Animation handling ---
func play_pop_up_anim():
	if has_node("tuts_anim"):
		$tuts_anim.play("pop_up_anim")

func play_pop_up_anim_reverse():
	if has_node("tuts_anim"):
		$tuts_anim.play_backwards("pop_up_anim")
		await $tuts_anim.animation_finished


# --- Label control logic ---
func _hide_all_labels() -> void:
	if not has_node("tutorialPanel/tutorialtextholder"):
		return
	
	for child in $tutorialPanel/tutorialtextholder.get_children():
		if child is Label:
			child.visible = false


func _show_current_label() -> void:
	var holder = $tutorialPanel/tutorialtextholder
	var labels = holder.get_children().filter(func(c): return c is Label)
	
	if current_label_index < labels.size():
		labels[current_label_index].visible = true
	else:
		_end_tutorial()


func _on_continue_butt_pressed() -> void:
	GlobalAudio.play_click()
	var holder = $tutorialPanel/tutorialtextholder
	if not holder:
		return
	
	var labels = holder.get_children().filter(func(c): return c is Label)

	# Hide current label if valid
	if current_label_index < labels.size():
		labels[current_label_index].visible = false

	current_label_index += 1

	# Define tutorial label index → target scene map
	var scene_map = {
		1: "res://Sample/sample_selection.tscn",
		2: "res://Sample/sample_scene.tscn",
		5: "res://Menu Scenes/notes_section.tscn",
		8: "res://Menu Scenes/settings_scene.tscn"
	}

	# If current label triggers a scene switch
	if scene_map.has(current_label_index):
		var target_scene = scene_map[current_label_index]

		# Reset GameState when going to sample scenes
		if target_scene == "res://Sample/sample_selection.tscn" or target_scene == "res://Sample/sample_scene.tscn":
			GameState.notes_index = 1
			GameState.lessons = 1
		else:
			GameState.notes_index = 0
			GameState.lessons = 0

		# Switch the scene, then call a deferred resume
		get_tree().change_scene_to_file(target_scene)
		call_deferred("_resume_after_scene_change")
		return

	# If all tutorial labels have been shown, return to main menu
	if current_label_index >= labels.size():
		get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")
		GameState.main_menu_index = 1
		queue_free()  # remove the tutorial mode layer
		return

	_show_current_label()




func _resume_after_scene_change() -> void:
	# Wait a few frames to make sure new scene fully loads
	await get_tree().process_frame

	var root = get_tree().get_root()

	# Ensure tutorial persists and stays on top
	if get_parent() != root:
		root.add_child(self)
		self.owner = null

	root.move_child(self, root.get_child_count() - 1)

	# Make sure tutorial panel is visible again
	if has_node("tutorialPanel"):
		$tutorialPanel.show()

	_show_current_label()





func _end_tutorial():
	if has_node("tutorialPanel"):
		$tutorialPanel.hide()
	GameState.first_time_play = false
	TutorialManager.stop_tutorial()
