extends Control


func _on_back_pressed() -> void:
	GlobalAudio.play_click()
	get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
