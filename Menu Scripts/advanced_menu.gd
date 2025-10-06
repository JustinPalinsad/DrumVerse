extends Control

func _ready() -> void:
	print(GameState.module_grades[24])
	grade_display()
	change_card()
	unlocked_advanced_lessons()

func _on_back_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")
	

func _on_free_pressed() -> void:
	GameState.notes_index = 0
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	#go back to main menu
	get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")


func _on_advance_lesson_11_pressed() -> void:
	GameState.lessons = 11
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module11.tres and Module11_Learning.tres...")

	var module_resource = load("res://Module/Lesson11/Module11.tres")
	var learning_resource = load("res://Module/Lesson11/Module11_learning.tres") #replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_12_pressed() -> void:
	GameState.lessons = 12
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module12.tres and Module12_Learning.tres...")

	var module_resource = load("res://Module/Lesson12/Module12.tres")
	var learning_resource = load("res://Module/Lesson12/Module12_learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_13_pressed() -> void:
	GameState.lessons = 13
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module13.tres and Module13_Learning.tres...")

	var module_resource = load("res://Module/Lesson13/Module13.tres")
	var learning_resource = load("res://Module/Lesson13/Module13_learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_14_pressed() -> void:
	GameState.lessons = 14
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module14.tres and Module14_Learning.tres...")

	var module_resource = load("res://Module/Lesson14/Module14.tres")
	var learning_resource = load("res://Module/Lesson14/Module14_learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_15_pressed() -> void:
	GameState.lessons = 15
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module15.tres and Module15_Learning.tres...")

	var module_resource = load("res://Module/Lesson15/Module15.tres")
	var learning_resource = load("res://Module/Lesson15/Module15_learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_16_pressed() -> void:
	GameState.lessons = 16
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module16.tres and Module16_Learning.tres...")

	var module_resource = load("res://Module/Lesson16/Module16.tres")
	var learning_resource = load("res://Module/Lesson16/Module16_learning.tres") #replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_17_pressed() -> void:
	GameState.lessons = 17
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module17.tres and Module17_Learning.tres...")

	var module_resource = load("res://Module/Lesson17/Module17.tres")
	var learning_resource = load("res://Module/Lesson17/Module17_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_18_pressed() -> void:
	GameState.lessons = 18
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module18.tres and Module18_Learning.tres...")

	var module_resource = load("res://Module/Lesson18/Module18.tres")
	var learning_resource = load("res://Module/Lesson18/Module18_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_19_pressed() -> void:
	GameState.lessons = 19
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module19.tres and Module19_Learning.tres...")

	var module_resource = load("res://Module/Lesson19/Module19.tres")
	var learning_resource = load("res://Module/Lesson19/Module19_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_20_pressed() -> void:
	GameState.lessons = 20
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module20.tres and Module20_Learning.tres...")

	var module_resource = load("res://Module/Lesson20/Module20.tres")
	var learning_resource = load("res://Module/Lesson20/Module20_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")

func _on_advance_lesson_21_pressed() -> void:
	GameState.lessons = 21
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module21.tres and Module21_Learning.tres...")

	var module_resource = load("res://Module/Lesson21/Module21.tres")
	var learning_resource = load("res://Module/Lesson21/Module21_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_advance_lesson_22_pressed() -> void:
	GameState.lessons = 22
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module22.tres and Module22_Learning.tres...")

	var module_resource = load("res://Module/Lesson22/Module22.tres")
	var learning_resource = load("res://Module/Lesson22/Module22_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_advance_lesson_23_pressed() -> void:
	GameState.lessons = 23
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module23.tres and Module23_Learning.tres...")

	var module_resource = load("res://Module/Lesson23/Module23.tres")
	var learning_resource = load("res://Module/Lesson23/Module23_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_advance_lesson_24_pressed() -> void:
	GameState.lessons = 24
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module24.tres and Module24_Learning.tres...")

	var module_resource = load("res://Module/Lesson24/Module24.tres")
	var learning_resource = load("res://Module/Lesson24/Module24_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")

func _goto_sample_scene() -> void:
	var sample_scene = load("res://Sample/sample_scene.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(sample_scene)
	get_tree().current_scene = sample_scene


func _on_advance_lesson_25_pressed() -> void: 
	GameState.lessons = 25
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	get_tree().change_scene_to_file("res://Sample/sample_scene.tscn")

func grade_display():
	for lesson_num in range(11, 26):
		var index = lesson_num - 1  # Lesson11 = index10
		var grade_text_node_path = "carousel_container_3/Control/AdvanceLesson" + str(lesson_num) + "/Grade Text"
		var grade_label = get_node_or_null(grade_text_node_path)
		if not grade_label:
			continue

		var grade = "N/A"
		if index < GameState.module_grades.size():
			grade = GameState.module_grades[index]

		grade_label.text = "Grade: " + grade


func change_card():
	var card_textures = [
		preload("res://Menu Assets/advanced cards/Lesson_Cards__011.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__012.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__013.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__014.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__015.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__016.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__017.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__018.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__019.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__020.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__021.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__022.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__023.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__024.png"),
		preload("res://Menu Assets/advanced cards/Lesson_Cards__025.png")
	]

	var locked_texture = preload("res://Menu Assets/Locked_Card.png")

	for lesson_num in range(11, 26):
		var index = lesson_num - 11  # texture index 0–14
		var lesson_node = $carousel_container_3/Control.get_node_or_null("AdvanceLesson" + str(lesson_num))
		if not lesson_node:
			print("Missing node: AdvanceLesson" + str(lesson_num))
			continue

		# Unlock Lesson11 only if Lesson10 was passed
		if lesson_num == 11:
			var grade_lesson10 = "N/A"
			if GameState.module_grades.size() > 9:
				grade_lesson10 = GameState.module_grades[9]

			if grade_lesson10 in ["S", "A", "B", "C"]:
				lesson_node.texture_normal = card_textures[index]
				print("✅ AdvanceLesson11 unlocked! Grade10:", grade_lesson10)
			else:
				lesson_node.texture_normal = locked_texture
			continue

		# For Lessons 12–25: unlock if previous advanced lesson passed
		var previous_index = 10 + (index - 1)
		var previous_grade = "N/A"
		if previous_index < GameState.module_grades.size():
			previous_grade = GameState.module_grades[previous_index]

		if previous_grade in ["S", "A", "B", "C"]:
			lesson_node.texture_normal = card_textures[index]
		else:
			lesson_node.texture_normal = locked_texture

func unlocked_advanced_lessons():
	# Loop through Advanced Lessons 11–25
	for lesson_num in range(11, 26):
		var lesson_node = $carousel_container_3/Control.get_node_or_null("AdvanceLesson" + str(lesson_num))
		if not lesson_node:
			print("⚠️ Missing node for AdvanceLesson" + str(lesson_num))
			continue

		var is_unlocked = false

		# Lesson 11 unlocks if Lesson 10 (index 9) is passed
		if lesson_num == 11:
			if GameState.module_grades.size() > 9:
				var grade_lesson10 = GameState.module_grades[9]
				is_unlocked = grade_lesson10 in ["S", "A", "B", "C"]
		else:
			# Lessons 12–25 unlock if previous advanced lesson is passed
			var prev_index = lesson_num - 2  # Lesson12 -> index10, Lesson13 -> index11, etc.
			if prev_index < GameState.module_grades.size():
				var prev_grade = GameState.module_grades[prev_index]
				is_unlocked = prev_grade in ["S", "A", "B", "C"]

		# --- Apply unlock state ---
		if is_unlocked:
			lesson_node.disabled = false
			for child in lesson_node.get_children():
				child.visible = true
			print("✅ AdvanceLesson" + str(lesson_num) + " unlocked!")
		else:
			lesson_node.disabled = true
			for child in lesson_node.get_children():
				if not (child is TextureButton):
					child.visible = false
			print("🔒 AdvanceLesson" + str(lesson_num) + " locked!")

func set_advanced_lessons_to_S():
	# Ensure GameState.module_grades is long enough
	while GameState.module_grades.size() < 25:
		GameState.module_grades.append("N/A")

	# Set Lessons 11–24 (indices 10–23) to "S"
	for i in range(10, 24):
		GameState.module_grades[i] = "S"

	print("✅ Lessons 11–24 grades set to 'S'!")

	# Optionally refresh UI right after
	if has_method("grade_display"):
		grade_display()
	if has_method("unlocked_advanced_lessons"):
		unlocked_advanced_lessons()


func _on_complete_grades_pressed() -> void:
	set_advanced_lessons_to_S()
