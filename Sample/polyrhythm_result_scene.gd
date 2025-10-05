extends Control

var total_hits = 0
var total_notes = 0
var total_misses = 0
var hit_percentage = 0.0
var grade = "N/A"
var mode = "practice"  # This is passed from the game scene

func _ready():
	# Display results
	$VBoxContainer/HitsLabel.text = "Hits: %d / %d" % [Results.total_hits, Results.total_notes]
	$VBoxContainer/MissesLabel.text = "Misses: %d" % Results.total_misses
	$VBoxContainer/AccuracyLabel.text = "Accuracy: " + str(round(Results.hit_percentage * 10) / 10.0) + "%"
	$VBoxContainer/GradeLabel.text = "Grade: %s" % Results.grade

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
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")
	hide()
