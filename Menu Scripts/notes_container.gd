extends Control

var main_scene: PackedScene = preload("res://Menu Scenes/notes_section.tscn")
var main_instance: Control = null
var last_note_resource = null

func _ready() -> void:
	chosen_note()
	update_selected_note_display()

func _process(_delta: float) -> void:
	if GameState.selected_notes_resource != last_note_resource:
		last_note_resource = GameState.selected_notes_resource
		update_selected_note_display()

func _on_visibility_changed() -> void:
	if not visible:
		set_process(false)
		set_process_input(false)
	else:
		set_process(true)
		set_process_input(true)

func update_selected_note_display() -> void:
	if GameState.selected_notes_resource != null:
		$Name.text = GameState.selected_notes_resource.Name
		
		if typeof(GameState.selected_notes_resource.ArrayDesc) == TYPE_ARRAY:
			$Description.text = "\n\n".join(GameState.selected_notes_resource.ArrayDesc)
		else:
			$Description.text = str(GameState.selected_notes_resource.ArrayDesc)
			
		$Icon.texture = GameState.selected_notes_resource.Icon
	else:
		$Name.text = "No Name"
		$Description.text = "No Description"
		$Icon.texture = null

func _on_back_pressed() -> void:
	show_section()

func chosen_note() -> void:
	var selected_note = GameState.notes
	var notes_container = $NotesIconContainer
	
	for child in notes_container.get_children():
		child.visible = (child.name == "Notes" + str(selected_note))

func set_main_instance(node: Control) -> void:
	main_instance = node

func show_section() -> void:
	# ✅ Only show an existing one — never create duplicates
	for node in get_tree().root.get_children():
		if node.name == "notes_section":
			main_instance = node
			break

	if main_instance and is_instance_valid(main_instance):
		main_instance.show()
	else:
		# Only instantiate if absolutely no instance exists
		main_instance = main_scene.instantiate() as Control
		main_instance.name = "notes_section"  # ensure consistent naming
		if main_instance.has_method("set_random_instance"):
			main_instance.set_random_instance(self)
		else:
			main_instance.random_instance = self
		get_tree().root.add_child(main_instance)
	
	hide()
