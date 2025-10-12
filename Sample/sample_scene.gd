extends Control

@onready var practice_button: TextureButton = $"Buttons Container/Practice"
@onready var challenge_button: TextureButton = $"Buttons Container/Challenge"
@onready var learning_button: TextureButton = $"Buttons Container/Learning"


func _ready() -> void:
	learning_button.pressed.connect(_on_learning_button_pressed)
	practice_button.pressed.connect(_on_practice_button_pressed)
	challenge_button.pressed.connect(_on_challenge_button_pressed)
	
	
	var selected_lesson = GameState.lessons
	print("Selected Lesson:", selected_lesson)

	# Get the VBoxContainer that holds the sprites
	var vbox = $"Lesson Container" # Adjust the path if different

	# Loop through all children and toggle visibility
	for child in vbox.get_children():
		if child.name == "Lesson%d" % selected_lesson:
			child.visible = true
		else:
			child.visible = false

func _on_learning_button_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.3).timeout
	if GameState.lessons == 25:
		GameState.polyrhythm_mode = "learning"
		get_tree().change_scene_to_file("res://Scenes/Modes/poly_test2.tscn")
	else:
		change_to_learning_scene("learning")


func _on_practice_button_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.3).timeout
	if GameState.lessons == 25:
		GameState.polyrhythm_mode = "practice"
		get_tree().change_scene_to_file("res://Scenes/Modes/poly_test2.tscn")
	else:
		change_to_game_scene("practice")

func _on_challenge_button_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.3).timeout
	if GameState.lessons == 25:
		GameState.polyrhythm_mode = "challenge"
		get_tree().change_scene_to_file("res://Scenes/Modes/poly_test2.tscn")
	else:
		change_to_game_scene("challenge")

func change_to_game_scene(mode: String) -> void:
	var loading_scene = load("res://Scenes/Shared/loading_screen.tscn") as PackedScene
	var loading_instance = loading_scene.instantiate()
	loading_instance.mode = mode
	loading_instance.drum_module = GameState.selected_module

	get_tree().root.add_child(loading_instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = loading_instance
	
func change_to_learning_scene(mode: String) -> void:
	var loading_scene = load("res://Scenes/Shared/loading_screen.tscn") as PackedScene
	var loading_instance = loading_scene.instantiate()
	loading_instance.mode = mode
	
	# Use the stored learning module from GameState
	var learning_module = GameState.selected_learning_module
	
	if learning_module:
		print("Using selected_learning_module from GameState.")
	else:
		push_error("selected_learning_module is null! Did you forget to set it in sample_selection?")
	
	# Set this on the loading_instance
	loading_instance.drum_module = learning_module

	get_tree().root.add_child(loading_instance)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = loading_instance




func _on_back_pressed() -> void:
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	if GameState.lessons < 11:
		get_tree().change_scene_to_file("res://Sample/sample_selection.tscn")
	else:
		get_tree().change_scene_to_file("res://Menu Scenes/advanced_menu.tscn")

func button_shake() -> void:
	var shake_strength := 25.0
	var shake_duration := 0.2
	var shake_count := 4

	var original_pos := position
	var tween := create_tween()

	for i in range(shake_count):
		var offset := Vector2(
			randf_range(-shake_strength, shake_strength),
			randf_range(-shake_strength, shake_strength)
		)
		tween.tween_property(self, "position", original_pos + offset, shake_duration / shake_count)

	tween.tween_property(self, "position", original_pos, shake_duration / shake_count)
