extends Node

@onready var global_click_sfx = $ClickSoundPlayerGlobal
@onready var global_bgm = $BGM
var bgm_bus = AudioServer.get_bus_index("BGM")

func play_click():
	global_click_sfx.play()
	
func play_bgm():
	if $BGM.playing == false:
		global_bgm.play()
	else:
		pass
func mute_bgm(is_muted: bool):
	AudioServer.set_bus_mute(bgm_bus, is_muted)
