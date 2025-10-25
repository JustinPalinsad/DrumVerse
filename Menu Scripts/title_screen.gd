extends Control

#variables ng animation player sa code
@onready var text_animPlayer = $"Tap Anywhere/Text Animation" #for text
@onready var drum_animPlayer = $"Control/Drum/Drum Animation" #for drum


func _ready() -> void:
	text_animPlayer.play("text_blink_animation")
	
func _on_start_button_pressed() -> void:
	# Disable input by hiding the button or setting its 'visible' to false

	$"Control2/Start Button".visible = false
	# alternatively, you can block input with:
	# start_button.set_process_input(false)
	
	text_animPlayer.play("text_blink_faster_animation")
	drum_animPlayer.play("drum_bounce_animation")
	$ClickSoundPlayer.play()
	await get_tree().create_timer(0.2).timeout
	GlobalAudio.play_bgm()
	print("Going to Main Menu...!")
	await text_animPlayer.animation_finished
	get_tree().change_scene_to_file("res://Menu Scenes/main_menu.tscn")
