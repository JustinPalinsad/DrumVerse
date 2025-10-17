extends CanvasLayer

func _ready() -> void:
	play_pop_up_anim()

func _on_yes_button_pressed() -> void:
	GameState.first_time_play = true
	await play_pop_up_anim_reverse()
	$MainPanel.hide()
	$tutorialText.show()

func _on_no_button_pressed() -> void:
	GameState.first_time_play = false
	await play_pop_up_anim_reverse()
	queue_free()

func play_pop_up_anim():
	$tuts_anim.play("pop_up_anim")
	
func play_pop_up_anim_reverse():
	$tuts_anim.play_backwards("pop_up_anim")
	await $tuts_anim.animation_finished

func tutorial_sequence():
	pass


func _on_continue_button_pressed() -> void:
	var holder = $tutorialText/tutorialtextholder
	var labels = holder.get_children().filter(func(c): return c is Label)

	# Run sequence: show one label, hide previous
	for i in range(labels.size()):
		# Hide all labels first
		for l in labels:
			l.visible = false

		# Show current label
		labels[i].visible = true

		# Wait before showing the next label
		await get_tree().create_timer(1.0).timeout  # adjust timing as needed

	# Optional: hide all after the sequence
	for l in labels:
		l.visible = false
