extends Node

var tutorial_instance: CanvasLayer = null

func start_tutorial():
	if tutorial_instance:
		return  # already running

	var scene = preload("res://Menu Scenes/tutorial_mode.tscn")
	tutorial_instance = scene.instantiate()
	get_tree().root.add_child(tutorial_instance)
	tutorial_instance.owner = null  # makes it survive scene changes

func stop_tutorial():
	if tutorial_instance:
		tutorial_instance.queue_free()
		tutorial_instance = null
