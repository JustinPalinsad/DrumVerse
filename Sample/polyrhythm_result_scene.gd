extends Control

var total_hits = 0
var total_notes = 0
var total_misses = 0
var hit_percentage = 0.0
var grade = "N/A"
var mode = "practice"  # This is passed from the game scene

func _ready():
		# Set corresponding value labels (white color)
	$HitsValue.text = "%d / %d" % [total_hits, total_notes]
	$MissesValue.text = str(total_misses)
	$AccuracyValue.text = str(round(hit_percentage * 1000) / 10.0) + "%"
	$GradeValue.text = grade

	var white = Color(1, 1, 1)
	var red = Color(1, 0, 0)

	$HitsValue.add_theme_color_override("font_color", white)
	$MissesValue.add_theme_color_override("font_color", white)
	$AccuracyValue.add_theme_color_override("font_color", white)

	# Grade color logic: white if valid text, red if empty or 'N/A'
	if grade.strip_edges() == "" or grade == "N/A":
		$GradeValue.add_theme_color_override("font_color", red)
	else:
		$GradeValue.add_theme_color_override("font_color", white)


	# Save grade for lesson 25 (index 24)
	save_lesson_25_grade()

	# Connect buttons
	$VBoxContainer/HBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)


func save_lesson_25_grade() -> void:
	var index := 24  # Lesson 25 index (0-based)
	
	# Ensure array is long enough
	if GameState.module_grades.size() < 25:
		for i in range(GameState.module_grades.size(), 25):
			GameState.module_grades.append("N/A")
	
	# Update the grade for lesson 25
	GameState.module_grades[index] = Results.grade
	
	# Save it to file
	GameState.save_grades()
	print("✅ Saved grade for Lesson 25:", Results.grade)
	print("Current module_grades:", GameState.module_grades)


func _on_menu_pressed():
	GlobalAudio.play_click()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/advanced_menu.tscn")
	hide()
