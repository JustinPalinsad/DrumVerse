extends Node

# --- Module and Lesson Tracking ---
var selected_module: DrumModuleData = null
var selected_learning_module: Resource = null
var selected_notes_resource: Resource

var mode: String = "practice"
var lessons: int = 0
var dark_mode_enabled: bool = true

var polyrhythm_mode: String = "learning"
var notes: int = 0

# --- Audio ---
var music_bus: int = AudioServer.get_bus_index("Master")
var is_muted: bool = false

# --- Indices ---
var notes_index: int = 0
var lesson_index: int = 0

# --- Grades and Results ---
const MAX_GRADES := 25
var module_grades: Array[String] = []
var last_results: Dictionary = {}   # 👈 stores results from the latest lesson (hits, misses, etc.)

# --- Save Path ---
const SAVE_PATH := "user://saved_data.save"

# --- UI / State Flags ---
var sample_selection_anim_has_played: bool = false
var notes_section_anim_has_played: bool = false
var main_menu_index: int = 1

var game_tutorial_active: bool = false
var input_locked: bool = false

# --- Tutorial / First Time ---
var first_time_play: bool = true:
	set(value):
		first_time_play = value
		save_data()  # Auto-save whenever this changes

# --- READY ---
func _ready() -> void:
	load_data()
	print("Loaded first_time_play:", first_time_play)
	print("Loaded grades:", module_grades)
	print("Loaded last_results:", last_results)


# --- SAVE FUNCTION ---
func save_data() -> void:
	# Ensure grades array is properly sized
	if module_grades.size() < MAX_GRADES:
		for i in range(module_grades.size(), MAX_GRADES):
			module_grades.append("N/A")

	var save_dict := {
		"module_grades": module_grades,
		"first_time_play": first_time_play,
		"last_results": last_results  # 👈 include last_results in save file
	}

	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(save_dict)
		file.close()
	else:
		printerr("❌ Failed to save data. Error code:", FileAccess.get_open_error())


# --- LOAD FUNCTION ---
func load_data() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if loaded_data is Dictionary:
				module_grades = loaded_data.get("module_grades", [])
				first_time_play = loaded_data.get("first_time_play", true)
				last_results = loaded_data.get("last_results", {})  # 👈 load saved results

				# Pad module_grades if missing entries
				for i in range(MAX_GRADES):
					if i >= module_grades.size():
						module_grades.append("N/A")
					elif module_grades[i] == null:
						module_grades[i] = "N/A"
			else:
				reset_grades()
			file.close()
		else:
			printerr("❌ Failed to open save file for reading. Error code:", FileAccess.get_open_error())
			reset_grades()
	else:
		reset_grades()


# --- RESET FUNCTION ---
func reset_grades() -> void:
	module_grades.clear()
	for i in range(MAX_GRADES):
		module_grades.append("N/A")

	last_results = {}         # 👈 reset last results
	first_time_play = true     # reset tutorial state
	save_data()                # save everything to file
