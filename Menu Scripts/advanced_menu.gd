extends Control


func _on_back_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")
	

func _on_free_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	#go back to main menu
	get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")

func _goto_sample_scene() -> void:
	var sample_scene = load("res://Sample/sample_scene.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(sample_scene)
	get_tree().current_scene = sample_scene


func _on_placeholderbuttons_pressed() -> void:
	GameState.lessons = 11
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module1.tres and Module1_Learning.tres...")

	var module_resource = load("res://Module/Lesson1/Module1.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource  # store learning version too
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
