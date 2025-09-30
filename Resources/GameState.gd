extends Node

var selected_module: DrumModuleData = null
var selected_learning_module: Resource = null

var selected_notes_resource : Resource

var mode: String = "practice"
var lessons = 0
var dark_mode_enabled: bool = true

var notes = 0

var polyrhythm_mode = "learning"

var module_grades: Array[String] = []
const SAVE_PATH = "user://saved_grades.save"

func _ready() -> void:
	load_grades()
	print(module_grades)

func save_grades() -> void:
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		file.store_var(module_grades)
	else:
		printerr("Failed to save grades. Error code: ", FileAccess.get_open_error())

func load_grades() -> void:
	if FileAccess.file_exists(SAVE_PATH):
		var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
		if file:
			var loaded_data = file.get_var()
			if loaded_data is Array:
				loaded_data.resize(10)
				module_grades = loaded_data
			else:
				reset_grades()
		else:
			printerr("Failed to open save file for reading. Error code: ", FileAccess.get_open_error())
			reset_grades()
	else:
		reset_grades()

func reset_grades() -> void:
	module_grades.clear()
	for i in range(10):
		module_grades.append("N/A")
