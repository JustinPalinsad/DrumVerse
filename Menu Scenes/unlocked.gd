extends Control


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if GameState.lessons > 10:
		get_tree().change_scene_to_file("res://Menu Scenes/advanced_menu.tscn")
	else: 
		get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
