extends MenuButton

# All possible BPMs
var all_bpms = [60, 80, 100]

# Custom font size
@export var popup_font_size: int = 22

func _ready() -> void:
	var menu = get_popup()
	menu.id_pressed.connect(_on_bpm_option_selected)

	# Apply font styling to popup
	_apply_popup_style(menu)

	# Default BPM
	_update_menu(60)

	# Rebuild menu every time before it’s shown
	menu.about_to_popup.connect(_on_about_to_popup)


func _on_about_to_popup() -> void:
	var current_bpm = int(text.replace("BPM: ", ""))
	_update_menu(current_bpm)


func _update_menu(current_bpm: int) -> void:
	var menu = get_popup()
	menu.clear()

	for bpm in all_bpms:
		if bpm != current_bpm:  # only show other BPMs
			menu.add_item("%d" % bpm)

	text = "BPM: %d" % current_bpm


func _on_bpm_option_selected(id: int) -> void:
	var menu = get_popup()
	var bpm_text = menu.get_item_text(id)
	var bpm_value = int(bpm_text.split(" ")[0])

	_update_menu(bpm_value)

	# Update the game scene
	var scene = get_tree().current_scene
	if scene and scene.has_method("update_bpm"):
		scene.update_bpm(bpm_value)


func _apply_popup_style(menu: PopupMenu) -> void:
	# Use the same font as MenuButton if available
	if has_theme_font("font"):
		var fnt = get_theme_font("font")
		menu.add_theme_font_override("font", fnt)

	# Override font size
	menu.add_theme_font_size_override("font_size", popup_font_size)

	# 🔹 Load ShaderMaterial color
	var mat = load("res://Menu Shaders/Asset_Color.tres")
	if mat and mat is ShaderMaterial:
		# ✅ Pick color based on dark mode (flipped)
		var color_value: Color
		var gs = get_node("/root/GameState")
		if gs:
			if gs.dark_mode_enabled:
				color_value = mat.get_shader_parameter("layer_color")  # 🔹 use layer_color in night mode
			else:
				color_value = mat.get_shader_parameter("layer_color")    # 🔹 use sub_color in day mode
		
		menu.add_theme_color_override("font_color", color_value)

	# Remove background/outline
	menu.add_theme_stylebox_override("panel", StyleBoxEmpty.new())

	# Keep hover highlight only
	var hover_box := StyleBoxFlat.new()
	hover_box.bg_color = Color(0.85, 0.85, 0.85, 0.8) # light gray, slightly transparent
	hover_box.corner_radius_top_left = 4
	hover_box.corner_radius_top_right = 4
	hover_box.corner_radius_bottom_left = 4
	hover_box.corner_radius_bottom_right = 4
	menu.add_theme_stylebox_override("hover", hover_box)
