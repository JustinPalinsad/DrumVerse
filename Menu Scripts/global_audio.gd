extends Node

@onready var global_click_sfx = $ClickSoundPlayerGlobal
@onready var global_bgm = $BGM

func play_click():
	global_click_sfx.play()
	
func play_bgm():
	if $BGM.playing == false:
		global_bgm.play()
	else:
		pass
	
