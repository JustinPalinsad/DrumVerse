extends Control

var total_hits = 0
var total_notes = 0
var total_misses = 0
var hit_percentage = 0.0
var grade = "N/A"
var mode = "practice"  # This is passed from the game scene

func _ready():
	# Set corresponding value labels
	$HitsValue.text = "%d / %d" % [total_hits, total_notes]
	$MissesValue.text = str(total_misses)
	$AccuracyValue.text = str(round(hit_percentage * 10) / 10.0) + "%"
	$GradeValue.text = grade

	var white = Color(1, 1, 1)
	var red = Color(1, 0, 0)

	$HitsValue.add_theme_color_override("font_color", white)
	$MissesValue.add_theme_color_override("font_color", white)
	$AccuracyValue.add_theme_color_override("font_color", white)

	# Grade color logic:
	# Red if grade is empty, N/A, F, or Fail (case-insensitive)
	
	if grade == "Failed":
		$GradeValue.add_theme_color_override("font_color", red)
	else:
		GameState.notes_index += 1
		$GradeValue.add_theme_color_override("font_color", white)

	# Connect button and save grades
	$VBoxContainer/HBoxContainer/MenuButton.pressed.connect(_on_menu_pressed)
	GameState.save_data()

func _on_menu_pressed():
	$ClickSoundPlayer.play()
	GlobalAudio.mute_bgm(false)
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")
	hide()
	if GameState.lessons > 10:
		get_tree().change_scene_to_file("res://Menu Scenes/advanced_menu.tscn")
	else: 
		get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
	#if grade == "Failed" and GameState.lessons > 10:
		#get_tree().change_scene_to_file("res://Menu Scenes/advanced_menu.tscn")
	#elif grade == "Failed" and GameState.lessons < 10:
		#get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
	#else:
		#get_tree().change_scene_to_file("res://Menu Scenes/unlocked.tscn")
