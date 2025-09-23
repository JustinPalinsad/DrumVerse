extends Control


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
	var loaded_resource = load("res://NotesResource/paradiddle.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_notes_20_pressed() -> void:
	GameState.notes = 20
	var loaded_resource = load("res://NotesResource/flam.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")


func _on_free_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
	


		
