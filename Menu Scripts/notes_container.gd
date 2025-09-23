extends Control

func _ready() -> void:
	chosen_note()
	if GameState.selected_notes_resource != null:
		$Name.text = GameState.selected_notes_resource.Name
		
		# Check if ArrayDesc is an array and join its elements with a newline
		if typeof(GameState.selected_notes_resource.ArrayDesc) == TYPE_ARRAY:
			$Description.text = "\n\n".join(GameState.selected_notes_resource.ArrayDesc)
		else:
			$Description.text = str(GameState.selected_notes_resource.ArrayDesc)
			
		$Icon.texture = GameState.selected_notes_resource.Icon
	else:
		$Name.text = "No Name"
		$Description.text = "No Description"
		print("No Icon")


func _on_back_pressed() -> void:
	if GameState.notes < 11:
		get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
	else:
		get_tree().change_scene_to_file("res://Menu Scenes/advanced_notes_section.tscn")

func chosen_note():
	var selected_note = GameState.notes
	
	var notes_container = $NotesIconContainer
	
	for child in notes_container.get_children():
		# Construct the expected name, e.g., "Notes1", "Notes2"
		var expected_name = "Notes" + str(selected_note)
		
		if child.name == expected_name:
			child.visible = true
		else:
			child.visible = false
