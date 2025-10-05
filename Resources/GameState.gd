extends Node

var selected_module: DrumModuleData = null
var selected_learning_module: Resource = null
var selected_notes_resource: Resource

var mode: String = "practice"
var lessons = 0
var dark_mode_enabled: bool = true

var polyrhythm_mode = "learning"
var notes = 0


var notes_index = 0
var lesson_index = 0

var module_grades: Array[String] = []
const SAVE_PATH = "user://saved_grades.save"
const MAX_GRADES = 25

func _ready() -> void:
	load_grades()
	print(module_grades)

func save_grades() -> void:
	# Ensure we always have exactly 25 entries
	if module_grades.size() < MAX_GRADES:
		for i in range(module_grades.size(), MAX_GRADES):
			module_grades.append("N/A")

	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(module_grades)
		file.close()
	else:
		printerr("Failed to save grades. Error code: ", FileAccess.get_open_error())

func load_grades() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if loaded_data is Array:
				module_grades = loaded_data.duplicate()
				# Fix null entries and pad missing ones
				for i in range(MAX_GRADES):
					if i >= module_grades.size():
						module_grades.append("N/A")
					elif module_grades[i] == null:
						module_grades[i] = "N/A"
			else:
				reset_grades()
			file.close()
		else:
			printerr("Failed to open save file for reading. Error code: ", FileAccess.get_open_error())
			reset_grades()
	else:
		reset_grades()

func reset_grades() -> void:
	module_grades.clear()
	for i in range(MAX_GRADES):
		module_grades.append("N/A")
