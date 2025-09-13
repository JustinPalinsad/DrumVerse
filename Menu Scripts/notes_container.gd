extends Control


func _ready() -> void:
	if GameState.selected_notes_resource != null:
		$NoteName.text = GameState.selected_notes_resource.Name
		
		# Join the array elements with two newline characters for a double line break.
		$NoteDescription.text = "\n\n".join(GameState.selected_notes_resource.ArrayDesc)
		
		$Icon.texture = GameState.selected_notes_resource.Icon
	else:
		print("No Note name and description")
		
func _on_back_pressed() -> void:
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
