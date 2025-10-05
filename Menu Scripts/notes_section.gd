extends Control

func _ready() -> void:
	change_card()
	
func _on_notes_1_pressed() -> void:
	GameState.notes = 1
	var loaded_resource = load("res://NotesResource/wholenote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_2_pressed() -> void:
	GameState.notes = 2
	var loaded_resource = load("res://NotesResource/halfnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_3_pressed() -> void:
	GameState.notes = 3
	var loaded_resource = load("res://NotesResource/quarternote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_4_pressed() -> void:
	GameState.notes = 4
	var loaded_resource = load("res://NotesResource/eightnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_5_pressed() -> void:
	GameState.notes = 5
	var loaded_resource = load("res://NotesResource/sixteenthnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_6_pressed() -> void:
	GameState.notes = 6
	var loaded_resource = load("res://NotesResource/triplet.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_7_pressed() -> void:
	GameState.notes = 7
	var loaded_resource = load("res://NotesResource/singlestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_8_pressed() -> void:
	GameState.notes = 8
	var loaded_resource = load("res://NotesResource/doublestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")

func _on_notes_9_pressed() -> void:
	GameState.notes = 9
	var loaded_resource = load("res://NotesResource/paradiddle.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_10_pressed() -> void:
	GameState.notes = 10
	var loaded_resource = load("res://NotesResource/flam.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")

func _on_advanced_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/advanced_notes_section.tscn")

func change_card():
	var card_textures = [
		preload("res://Menu Assets/cards v2/Lesson_Cards_001.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_002.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_003.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_004.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_005.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_006.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_007.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_008.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_009.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_010.png")
	]

	var locked_texture = preload("res://Menu Assets/Locked_Card.png")

	for i in range(card_textures.size()):
		var lesson_num = i + 1
		var lesson_node = $CarouselContainer2/Control.get_node("Notes" + str(lesson_num))
		if not lesson_node:
			continue

		# ✅ Fix: use current index for checking unlock condition, not i - 1
		var current_grade = GameState.module_grades[i] if i < GameState.module_grades.size() else "N/A"

		if current_grade in ["S", "A", "B", "C"]:
			lesson_node.texture_normal = card_textures[i]
			lesson_node.disabled = false
		else:
			lesson_node.texture_normal = locked_texture
			lesson_node.disabled = true
			
func show_notes_section():
	var notes_section_scene = preload("res://Menu Scenes/notes_container.tscn")
	get_tree().root.add_child(notes_section_scene)
