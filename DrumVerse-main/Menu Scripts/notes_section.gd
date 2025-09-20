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
