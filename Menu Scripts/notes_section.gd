extends Control



func _on_back_pressed() -> void:
	GameState.notes_carousel_index = 0
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")


func _on_lesson_1_pressed() -> void:
	var loaded_resource = load("res://Notes Section/wholenote.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_2_pressed() -> void:
	var loaded_resource = load("res://Notes Section/halfnote.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_3_pressed() -> void:
	var loaded_resource = load("res://Notes Section/quarternote.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_4_pressed() -> void:
	var loaded_resource = load("res://Notes Section/eightnotes.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_5_pressed() -> void:
	var loaded_resource = load("res://Notes Section/sixteenthnotes.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_6_pressed() -> void:
	var loaded_resource = load("res://Notes Section/triplets.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_7_pressed() -> void:
	var loaded_resource = load("res://Notes Section/singlestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_8_pressed() -> void:
	var loaded_resource = load("res://Notes Section/doublestroke.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_9_pressed() -> void:
	var loaded_resource = load("res://Notes Section/paradiddle.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")


func _on_lesson_10_pressed() -> void:
	var loaded_resource = load("res://Notes Section/flam.tres")
	GameState.selected_notes_resource = loaded_resource
	$BackSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/notes_container.tscn")
