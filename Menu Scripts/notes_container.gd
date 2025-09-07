extends Control


func _on_back_pressed() -> void:
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_section.tscn")
