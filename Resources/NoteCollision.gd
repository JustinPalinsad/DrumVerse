extends Node2D

#@onready var sprite: Sprite2D = get_node("Sprite2D")

func _ready():
	var beams = get_node("BeamContainer").get_children()
	var drum_note: DrumNote = null

	# 🔹 Only fetch if the meta exists
	if has_meta("drum_note_resource"):
		drum_note = get_meta("drum_note_resource")

	for i in range(beams.size()):
		var beam = beams[i]
		if beam.has_method("is_beam") and beam.is_beam():
			beam.parent_note = self

			# Only assign pads if the DrumNote exists
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
