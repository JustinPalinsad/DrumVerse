extends Control

func _ready() -> void:
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
	get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
