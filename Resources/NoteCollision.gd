extends Node2D

@onready var sprite: Sprite2D = get_node("Sprite2D")

func _ready():
	var beams = get_node("BeamContainer").get_children()
	var drum_note: DrumNote = get_meta("drum_note_resource")  # Assigned in spawn_notes_from_bar

	for i in beams.size():
		var beam = beams[i]
		if beam.has_method("is_beam") and beam.is_beam():
			beam.parent_note = self

			# Assign pad based on DrumNote property
			if drum_note:
				match i:
					0:
						beam.required_pad = drum_note.pad_beam_1
					1:
						beam.required_pad = drum_note.pad_beam_2
					2:
						beam.required_pad = drum_note.pad_beam_3
					3:
						beam.required_pad = drum_note.pad_beam_4

			beam.update_label()

	print("Ready! Total beams in this note:", beams.size())
