extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")

func _on_lesson_1_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/wholenote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")



func _on_lesson_2_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/halfnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_3_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/quarternote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_4_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/eightnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_5_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/eightnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_6_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/sixteenthnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_7_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/singlestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_8_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/doublestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_9_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/paradiddle.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")


func _on_lesson_10_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/flam.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")
