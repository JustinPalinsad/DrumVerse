extends Control

func _ready() -> void:
	change_card()
	
func _on_notes_11_pressed() -> void:
	GameState.notes = 11
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missinge.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_12_pressed() -> void:
	GameState.notes = 12
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missingn.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_13_pressed() -> void:
	GameState.notes = 13
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missingna.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_14_pressed() -> void:
	GameState.notes = 14
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missing1.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_15_pressed() -> void:
	GameState.notes = 15
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missing1e.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_16_pressed() -> void:
	GameState.notes = 16
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missingen.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_17_pressed() -> void:
	GameState.notes = 17
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missingna.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_18_pressed() -> void:
	GameState.notes = 18
	var loaded_resource = load("res://NotesResource/advanced notes resource/broken16missing1a.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")

func _on_notes_19_pressed() -> void:
	GameState.notes = 19
	var loaded_resource = load("res://NotesResource/advanced notes resource/paradiddle_diddle.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_20_pressed() -> void:
	GameState.notes = 20
	var loaded_resource = load("res://NotesResource/advanced notes resource/double_paradiddle.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")


func _on_free_pressed() -> void:
	GameState.notes_index = 0
	get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
	if GameState.notes_index > 0:
		GameState.notes_index = 0
		print(GameState.notes_index)
	


func _on_notes_21_pressed() -> void:
	GameState.notes = 21
	var loaded_resource = load("res://NotesResource/advanced notes resource/five_stroke_roll.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_22_pressed() -> void:
	GameState.notes = 22
	var loaded_resource = load("res://NotesResource/advanced notes resource/six_stroke_roll.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_23_pressed() -> void:
	GameState.notes = 23
	var loaded_resource = load("res://NotesResource/advanced notes resource/seven_stroke_roll.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_24_pressed() -> void:
	GameState.notes = 24
	var loaded_resource = load("res://NotesResource/advanced notes resource/swiss_army_triplet.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_25_pressed() -> void:
	GameState.notes = 25
	var loaded_resource = load("res://NotesResource/advanced notes resource/polyrhythm.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")

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
		var lesson_node = $CarouselContainer2/Control.get_node_or_null("Notes" + str(lesson_num))
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
				lesson_node.disabled = false
			else:
				lesson_node.texture_normal = locked_texture
				lesson_node.disabled = true
			continue

		# For Lessons 12–25: unlock if previous advanced lesson passed
		var previous_index = 10 + (index - 1)
		var previous_grade = "N/A"
		if previous_index < GameState.module_grades.size():
			previous_grade = GameState.module_grades[previous_index]

		if previous_grade in ["S", "A", "B", "C"]:
			lesson_node.texture_normal = card_textures[index]
			lesson_node.disabled = false
		else:
			lesson_node.texture_normal = locked_texture
			lesson_node.disabled = true
