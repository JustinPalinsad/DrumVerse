extends Control  

@onready var sprite := $"DarkMode Button"
@onready var button := $"DarkMode Button"
@onready var sound_toggle := $"SoundToggle"

const COLOR_YELLOW := Color("ffc025")
const COLOR_BROWN := Color("30170c")
const LIGHT_TEXTURE := preload("res://Menu Assets/LightMode.png")
const DARK_TEXTURE := preload("res://Menu Assets/DarkMode.png")

const SOUND_ON := preload("res://Menu Assets/Sound.png")
const SOUND_OFF := preload("res://Menu Assets/Sound_Mute.png")

func _ready() -> void:
	# Ensure GameState.is_muted exists, default false
	if not "is_muted" in GameState:
		GameState.is_muted = AudioServer.is_bus_mute(GameState.music_bus)
	else:
		AudioServer.set_bus_mute(GameState.music_bus, GameState.is_muted)

	check_mute()

	# Apply dark mode visuals
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

	button.texture_pressed = null


func _on_back_pressed() -> void:
	GlobalAudio.play_click()
	#await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")


func _on_sound_toggle_pressed() -> void:
	# Toggle mute
	GameState.is_muted = not GameState.is_muted
	AudioServer.set_bus_mute(GameState.music_bus, GameState.is_muted)

	# Update the button texture immediately
	check_mute()

	# Play click sound only if not muted
	if not GameState.is_muted:
		$Sound.play()



func check_mute() -> void:
	if GameState.is_muted:
		sound_toggle.texture_normal = SOUND_OFF
	else:
		sound_toggle.texture_normal = SOUND_ON

	# Disable the pressed texture so it won't show when clicked
	sound_toggle.texture_pressed = null



func _on_button_pressed() -> void:
	GameState.reset_grades()
	GameState.save_grades()


func _on_button_2_pressed() -> void:
	GameState.module_grades = ['S','S','S','S','S','S','S','S','S','S']
	set_advanced_lessons_to_S()


func set_advanced_lessons_to_S():
	while GameState.module_grades.size() < 25:
		GameState.module_grades.append("N/A")
	for i in range(10, 25):
		GameState.module_grades[i] = "S"
	print("✅ Lessons 11–24 grades set to 'S'!")
