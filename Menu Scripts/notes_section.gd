extends Control



func _on_back_pressed() -> void:
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")


func _on_lesson_1_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_2_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_3_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_4_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_5_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_6_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_7_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_8_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_9_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_10_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")
