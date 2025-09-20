extends Control


func _on_notes_1_pressed() -> void:
	var loaded_resource = load("res://NotesResource/wholenote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_2_pressed() -> void:
	var loaded_resource = load("res://NotesResource/halfnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_3_pressed() -> void:
	var loaded_resource = load("res://NotesResource/quarternote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_4_pressed() -> void:
	var loaded_resource = load("res://NotesResource/eightnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_5_pressed() -> void:
	var loaded_resource = load("res://NotesResource/sixteenthnote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_6_pressed() -> void:
	var loaded_resource = load("res://NotesResource/triplet.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_7_pressed() -> void:
	var loaded_resource = load("res://NotesResource/singlestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_8_pressed() -> void:
	var loaded_resource = load("res://NotesResource/doublestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")

func _on_notes_9_pressed() -> void:
	var loaded_resource = load("res://NotesResource/paradiddle.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_10_pressed() -> void:
	var loaded_resource = load("res://NotesResource/flam.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")
