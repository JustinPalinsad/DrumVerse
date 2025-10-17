extends Node

var selected_module: DrumModuleData = null
var selected_learning_module: Resource = null
var selected_notes_resource: Resource

var mode: String = "practice"
var lessons = 0
var dark_mode_enabled: bool = true

var polyrhythm_mode = "learning"
var notes = 0

var music_bus = AudioServer.get_bus_index("Master")
var is_muted: bool = false

var notes_index: int = 0
var lesson_index = 0

var module_grades: Array[String] = []
const SAVE_PATH = "user://saved_data.save"
const MAX_GRADES = 25

var sample_selection_anim_has_played = false
var notes_section_anim_has_played = false
var main_menu_index = 1

var game_tutorial_active: bool = false
var input_locked: bool = false

var first_time_play: bool = true:
	set(value):
		first_time_play = value
		save_data()  # Auto-save when changed

func _ready() -> void:
	load_data()
	print("Loaded first_time_play:", first_time_play)


func save_data() -> void:
	# Ensure grades are properly padded
	if module_grades.size() < MAX_GRADES:
		for i in range(module_grades.size(), MAX_GRADES):
			module_grades.append("N/A")

	var save_dict = {
		"module_grades": module_grades,
		"first_time_play": first_time_play
	}

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_dict)
		file.close()
	else:
		printerr("Failed to save data. Error code:", FileAccess.get_open_error())


func load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if loaded_data is Dictionary:
				module_grades = loaded_data.get("module_grades", [])
				first_time_play = loaded_data.get("first_time_play", true)
				# Pad or fix grade entries
				for i in range(MAX_GRADES):
					if i >= module_grades.size():
						module_grades.append("N/A")
					elif module_grades[i] == null:
						module_grades[i] = "N/A"
			else:
				reset_grades()
			file.close()
		else:
			printerr("Failed to open save file for reading. Error code:", FileAccess.get_open_error())
			reset_grades()
	else:
		reset_grades()


func reset_grades() -> void:
	module_grades.clear()
	for i in range(MAX_GRADES):
		module_grades.append("N/A")
	
	first_time_play = true  # Reset tutorial state
	save_data()  # Save both grades and first_time_play
