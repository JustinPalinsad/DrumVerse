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


func _on_advance_lesson_11_pressed() -> void:
	GameState.lessons = 11
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module11.tres and Module11_Learning.tres...")

	var module_resource = load("res://Module/Lesson11/Module11.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_12_pressed() -> void:
	GameState.lessons = 12
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module12.tres and Module12_Learning.tres...")

	var module_resource = load("res://Module/Lesson12/Module12.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_13_pressed() -> void:
	GameState.lessons = 13
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module13.tres and Module13_Learning.tres...")

	var module_resource = load("res://Module/Lesson13/Module13.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_14_pressed() -> void:
	GameState.lessons = 14
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module14.tres and Module14_Learning.tres...")

	var module_resource = load("res://Module/Lesson14/Module14.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_15_pressed() -> void:
	GameState.lessons = 15
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module15.tres and Module15_Learning.tres...")

	var module_resource = load("res://Module/Lesson15/Module15.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")#replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_16_pressed() -> void:
	GameState.lessons = 16
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module16.tres and Module16_Learning.tres...")

	var module_resource = load("res://Module/Lesson16/Module16.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres") #replace this
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


func _on_advance_lesson_17_pressed() -> void:
	GameState.lessons = 17
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module17.tres and Module17_Learning.tres...")

	var module_resource = load("res://Module/Lesson17/Module17.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")


#func _on_advance_lesson_18_pressed() -> void:
	#GameState.lessons = 18
	#$ClickSoundPlayer.play()
	#await get_tree().create_timer(0.2).timeout
	#
	#print("Loading Module18.tres and Module18_Learning.tres...")
#
	#var module_resource = load("res://Module/Lesson18/Module18.tres")
	#var learning_resource = load("res://Module/Lesson18/Module18_Learning.tres")
	#
	#if module_resource and learning_resource:
		#print("Both module and learning module loaded.")
		#GameState.selected_module = module_resource
		#GameState.selected_learning_module = learning_resource
		#call_deferred("_goto_sample_scene")
	#else:
		#push_error("Failed to load module or learning module!")
#
#
#func _on_advance_lesson_19_pressed() -> void:
	#GameState.lessons = 19
	#$ClickSoundPlayer.play()
	#await get_tree().create_timer(0.2).timeout
	#
	#print("Loading Module19.tres and Module19_Learning.tres...")
#
	#var module_resource = load("res://Module/Lesson19/Module19.tres")
	#var learning_resource = load("res://Module/Lesson19/Module19_Learning.tres")
	#
	#if module_resource and learning_resource:
		#print("Both module and learning module loaded.")
		#GameState.selected_module = module_resource
		#GameState.selected_learning_module = learning_resource
		#call_deferred("_goto_sample_scene")
	#else:
		#push_error("Failed to load module or learning module!")
#
#
#func _on_advance_lesson_20_pressed() -> void:
	#GameState.lessons = 20
	#$ClickSoundPlayer.play()
	#await get_tree().create_timer(0.2).timeout
	#
	#print("Loading Module20.tres and Module20_Learning.tres...")
#
	#var module_resource = load("res://Module/Lesson20/Module20.tres")
	#var learning_resource = load("res://Module/Lesson20/Module20_Learning.tres")
	#
	#if module_resource and learning_resource:
		#print("Both module and learning module loaded.")
		#GameState.selected_module = module_resource
		#GameState.selected_learning_module = learning_resource
		#call_deferred("_goto_sample_scene")
	#else:
		#push_error("Failed to load module or learning module!")
		
func _goto_sample_scene() -> void:
	var sample_scene = load("res://Sample/sample_scene.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(sample_scene)
	get_tree().current_scene = sample_scene
