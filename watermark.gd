extends CanvasLayer

func _ready():
	var label = Label.new()
	label.text = "TEST BUILD - NOT FOR DISTRIBUTION"
	label.modulate.a = 0.2
	label.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER

	# 🧩 Create a LabelSettings to control font size
	var settings = LabelSettings.new()
	settings.font_size = 48  # Increase or change this value as needed
	label.label_settings = settings

	add_child(label)
