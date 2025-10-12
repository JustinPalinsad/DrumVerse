extends Node

@onready var global_click_sfx = $ClickSoundPlayerGlobal

func play_click():
	global_click_sfx.play()
