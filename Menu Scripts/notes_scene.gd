extends Control


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")



func _on_lesson_1_pressed() -> void:
	var loaded_resource = load("res://Notes Resource/wholenote.tres")
	GameState.selected_notes_resource = loaded_resource
	get_tree().change_scene_to_file("res://Menu Scenes/notes_content.tscn")
