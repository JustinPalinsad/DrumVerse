@tool
extends Control

@onready var module1_button: TextureButton = $CarouselContainer/Control/Lesson1
@onready var module2_button: TextureButton = $CarouselContainer/Control/Lesson2
@onready var module3_button: TextureButton = $CarouselContainer/Control/Lesson3
@onready var module4_button: TextureButton = $CarouselContainer/Control/Lesson4
@onready var module5_button: TextureButton = $CarouselContainer/Control/Lesson5
@onready var module6_button: TextureButton = $CarouselContainer/Control/Lesson6
@onready var module7_button: TextureButton = $CarouselContainer/Control/Lesson7
@onready var module8_button: TextureButton = $CarouselContainer/Control/Lesson8
@onready var module9_button: TextureButton = $CarouselContainer/Control/Lesson9
@onready var module10_button: TextureButton = $CarouselContainer/Control/Lesson10


var module_callbacks = {
	1: _on_module1_button_pressed,
	2: _on_module2_button_pressed,
	3: _on_module3_button_pressed,
	4: _on_module4_button_pressed,
	5: _on_module5_button_pressed,
	6: _on_module6_button_pressed,
	7: _on_module7_button_pressed,
	8: _on_module8_button_pressed,
	9: _on_module9_button_pressed,
	10: _on_module10_button_pressed
}

func _ready() -> void:
	module1_button.pressed.connect(_on_module1_button_pressed)
	module2_button.pressed.connect(_on_module2_button_pressed)
	module3_button.pressed.connect(_on_module3_button_pressed)
	module4_button.pressed.connect(_on_module4_button_pressed)
	module5_button.pressed.connect(_on_module5_button_pressed)
	module6_button.pressed.connect(_on_module6_button_pressed)
	module7_button.pressed.connect(_on_module7_button_pressed)
	module8_button.pressed.connect(_on_module8_button_pressed)
	module9_button.pressed.connect(_on_module9_button_pressed)
	module10_button.pressed.connect(_on_module10_button_pressed)
	
	print("GameState is loaded: ", GameState)
	
	grade_display()
	change_card()
	unlocked_lesson()

func _on_module1_button_pressed() -> void:
	GameState.lessons = 1
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module1.tres and Module1_Learning.tres...")

	var module_resource = load("res://Module/Lesson1/Module1.tres")
	var learning_resource = load("res://Module/Lesson1/Module1_Learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")

func _on_module2_button_pressed() -> void:
	GameState.lessons = 2
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module2.tres and Module2_Learning.tres...")

	var module_resource = load("res://Module/Lesson2/Module2.tres")
	var learning_resource = load("res://Module/Lesson2/Module2_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_module3_button_pressed() -> void:
	GameState.lessons = 3
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module3.tres and Module3_Learning.tres...")

	var module_resource = load("res://Module/Lesson3/Module3.tres")
	var learning_resource = load("res://Module/Lesson3/Module3_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
	
func _on_module4_button_pressed() -> void:
	GameState.lessons = 4
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	
	print("Loading Module4.tres and Module4_Learning.tres...")

	var module_resource = load("res://Module/Lesson4/Module4.tres")
	var learning_resource = load("res://Module/Lesson4/Module4_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_module5_button_pressed() -> void:
	GameState.lessons = 5
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	print("Loading Module5.tres and Module5_Learning.tres...")

	var module_resource = load("res://Module/Lesson5/Module5.tres")
	var learning_resource = load("res://Module/Lesson5/Module5_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_module6_button_pressed() -> void:
	GameState.lessons = 6
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	print("Loading Module6.tres and Module6_Learning.tres...")

	var module_resource = load("res://Module/Lesson6/Module6.tres")
	var learning_resource = load("res://Module/Lesson6/Module6_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
		
func _on_module7_button_pressed() -> void:
	GameState.lessons = 7
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	print("Loading Module7.tres and Module7_Learning.tres...")

	var module_resource = load("res://Module/Lesson7/Module7.tres")
	var learning_resource = load("res://Module/Lesson7/Module7_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
	
func _on_module8_button_pressed() -> void:
	GameState.lessons = 8
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	print("Loading Module8.tres and Module8_Learning.tres...")

	var module_resource = load("res://Module/Lesson8/Module8.tres")
	var learning_resource = load("res://Module/Lesson8/Module8_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
	
func _on_module9_button_pressed() -> void:
	GameState.lessons = 9
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	print("Loading Module9.tres and Module9_Learning.tres...")

	var module_resource = load("res://Module/Lesson9/Module9.tres")
	var learning_resource = load("res://Module/Lesson9/Module9_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")
	
func _on_module10_button_pressed() -> void:
	GameState.lessons = 10
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	print("Loading Module10.tres and Module10_Learning.tres...")

	var module_resource = load("res://Module/Lesson10/Module10.tres")
	var learning_resource = load("res://Module/Lesson10/Module10_learning.tres")
	
	if module_resource and learning_resource:
		print("Both module and learning module loaded.")
		GameState.selected_module = module_resource
		GameState.selected_learning_module = learning_resource
		call_deferred("_goto_sample_scene")
	else:
		push_error("Failed to load module or learning module!")

func _goto_sample_scene() -> void:
	var sample_scene = load("res://Sample/sample_scene.tscn").instantiate()
	get_tree().current_scene.queue_free()
	get_tree().root.add_child(sample_scene)
	get_tree().current_scene = sample_scene
	
func _on_back_pressed() -> void:
	GameState.notes_index = 0
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")

func _on_play_area_area_entered(area: Area2D) -> void:
	if area.name.begins_with("Lesson"):
		var lesson_str = area.name.substr(6)
		var lesson_num = int(lesson_str)
		if lesson_num >= 1 and lesson_num <= 10:
			$CardSwipeSFX.play()
			GameState.lessons = lesson_num
			print("Entered at " + str(GameState.lessons))

func _on_play_area_area_exited(area: Area2D) -> void:
	print("Exited")

func _on_play_pressed() -> void:
	if GameState.lessons in module_callbacks:
		module_callbacks[GameState.lessons].call()
	else:
		print("No centered module for lesson: ", GameState.lessons)

func _on_up_pressed() -> void:
	$CarouselContainer._up()

func _on_down_pressed() -> void:
	$CarouselContainer._down()
	
func grade_display():
	$"CarouselContainer/Control/Lesson1/Grade Text".text = "Grade: " + GameState.module_grades[0]
	$"CarouselContainer/Control/Lesson2/Grade Text".text = "Grade: " + GameState.module_grades[1]
	$"CarouselContainer/Control/Lesson3/Grade Text".text = "Grade: " + GameState.module_grades[2]
	$"CarouselContainer/Control/Lesson4/Grade Text".text = "Grade: " + GameState.module_grades[3]
	$"CarouselContainer/Control/Lesson5/Grade Text".text = "Grade: " + GameState.module_grades[4]
	$"CarouselContainer/Control/Lesson6/Grade Text".text = "Grade: " + GameState.module_grades[5]
	$"CarouselContainer/Control/Lesson7/Grade Text".text = "Grade: " + GameState.module_grades[6]
	$"CarouselContainer/Control/Lesson8/Grade Text".text = "Grade: " + GameState.module_grades[7]
	$"CarouselContainer/Control/Lesson9/Grade Text".text = "Grade: " + GameState.module_grades[8]
	$"CarouselContainer/Control/Lesson10/Grade Text".text = "Grade: " + GameState.module_grades[9]
	
## Fix for Lesson Unlocking

func unlocked_lesson():
	# Lesson 1 is always unlocked
	var lesson1 = $CarouselContainer/Control/Lesson1
	if lesson1:
		lesson1.disabled = false
		for child in lesson1.get_children():
			child.visible = true

	# Loop from Lesson 2 to Lesson 10
	for i in range(1, 10):
		var lesson_num = i + 1
		var lesson_node = $CarouselContainer/Control.get_node("Lesson" + str(lesson_num))
		var previous_grade = GameState.module_grades[i - 1] if i - 1 < GameState.module_grades.size() else "N/A"

		if lesson_node:
			# UNLOCK only if previous grade is PASSED (S, A, B, or C)
			if previous_grade in ["S", "A", "B", "C"]:
				lesson_node.disabled = false
				for child in lesson_node.get_children():
					child.visible = true
			else:
				# LOCK if previous grade is "Fail" or "N/A"
				lesson_node.disabled = true
				for child in lesson_node.get_children():
					# Keep texture button visible (so lock image shows), hide other elements
					if not (child is TextureButton):
						child.visible = false


## Updated Card Changing Logic

func change_card():
	var card_textures = [
		preload("res://Menu Assets/cards v2/Lesson_Cards_001.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_002.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_003.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_004.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_005.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_006.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_007.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_008.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_009.png"),
		preload("res://Menu Assets/cards v2/Lesson_Cards_010.png")
	]

	var locked_texture = preload("res://Menu Assets/Locked_Card.png")

	for i in range(10):
		var lesson_num = i + 1
		var lesson_node = $CarouselContainer/Control.get_node("Lesson" + str(lesson_num))
		if not lesson_node:
			continue

		if i == 0:
			lesson_node.texture_normal = card_textures[i]  # Lesson 1 always unlocked
			continue

		var previous_grade = GameState.module_grades[i - 1] if i - 1 < GameState.module_grades.size() else "N/A"

		if previous_grade in ["S", "A", "B", "C"]:
			lesson_node.texture_normal = card_textures[i]
		else:
			lesson_node.texture_normal = locked_texture

	
func _on_advanced_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/advanced_menu.tscn")

func _on_complete_grades_pressed() -> void:
	GameState.module_grades = ['S','S','S','S','S','S','S','S','S','S']
	print("New Module Grades: ", GameState.module_grades)
