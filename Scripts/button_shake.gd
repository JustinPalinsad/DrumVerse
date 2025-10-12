extends TextureButton

func _ready() -> void:
	# Automatically connect its own pressed signal to the shake function
	pressed.connect(button_shake)

func button_shake() -> void:
	GlobalAudio.play_click()
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
