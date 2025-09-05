extends Control


func _ready() -> void:
	if GameState.selected_notes_resource != null:
		$Name.text = GameState.selected_notes_resource.name
		$Description.text = GameState.selected_notes_resource.description
		$NoteIcon.texture = GameState.selected_notes_resource.icon
	else:
		$Name.text = "No Name"
		$Description.text = "No Description"
		print("No Icon")
		
func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://Menu Scenes/notes_scene.tscn")
