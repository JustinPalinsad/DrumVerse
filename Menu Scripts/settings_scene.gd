extends Control  

@onready var sprite := $"DarkMode Button"
@onready var button := $"DarkMode Button"

const COLOR_YELLOW := Color("ffc025")
const COLOR_BROWN := Color("30170c")
const LIGHT_TEXTURE := preload("res://Menu Assets/LightMode.png")
const DARK_TEXTURE := preload("res://Menu Assets/DarkMode.png")

func _ready() -> void:
	# Apply dark mode state when the scene loads
	var mat := sprite.material as ShaderMaterial
	if mat:
		if GameState.dark_mode_enabled:
			mat.set_shader_parameter("layer_color", COLOR_BROWN)
			mat.set_shader_parameter("sub_color", COLOR_YELLOW)
			button.texture_normal = LIGHT_TEXTURE  # Show light icon when in dark mode
			RenderingServer.set_default_clear_color(COLOR_YELLOW)
		else:
			mat.set_shader_parameter("layer_color", COLOR_YELLOW)
			mat.set_shader_parameter("sub_color", COLOR_BROWN)
			button.texture_normal = DARK_TEXTURE  # Show dark icon when in light mode
			RenderingServer.set_default_clear_color(COLOR_BROWN)

	# Optional: disable texture_pressed to prevent flicker
	button.texture_pressed = null

func _on_dark_mode_button_pressed() -> void:
	$Sound.play()
	await get_tree().create_timer(0.2).timeout

	GameState.dark_mode_enabled = !GameState.dark_mode_enabled

	var mat := sprite.material as ShaderMaterial
	if mat:
		if GameState.dark_mode_enabled:
			mat.set_shader_parameter("layer_color", COLOR_BROWN)
			mat.set_shader_parameter("sub_color", COLOR_YELLOW)
			button.texture_normal = LIGHT_TEXTURE
			RenderingServer.set_default_clear_color(COLOR_YELLOW)
		else:
			mat.set_shader_parameter("layer_color", COLOR_YELLOW)
			mat.set_shader_parameter("sub_color", COLOR_BROWN)
			button.texture_normal = DARK_TEXTURE
			RenderingServer.set_default_clear_color(COLOR_BROWN)

	# Optional: reset pressed texture to avoid it showing
	button.texture_pressed = null

func _on_back_pressed() -> void:
	$Sound.play()
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")


func _on_sound_toggle_pressed() -> void:
	$Sound.play()
	pass # Replace with function body.

func _on_button_pressed() -> void:
	GameState.reset_grades()
	GameState.save_grades()


func _on_button_2_pressed() -> void:
	GameState.module_grades = ['S','S','S','S','S','S','S','S','S','S']
	set_advanced_lessons_to_S()

func set_advanced_lessons_to_S():
	# Ensure GameState.module_grades is long enough
	while GameState.module_grades.size() < 25:
		GameState.module_grades.append("N/A")

	# Set Lessons 11–24 (indices 10–23) to "S"
	for i in range(10, 25):
		GameState.module_grades[i] = "S"

	print("✅ Lessons 11–24 grades set to 'S'!")
