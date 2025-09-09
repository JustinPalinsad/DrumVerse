extends Resource
class_name DrumNote

@export var x_position: float
@export var note_scene: PackedScene

# Pad per beam. Add as many as needed for your notes
@export_enum("left", "right", "both") var pad_beam_1: String = "both"
@export_enum("left", "right", "both") var pad_beam_2: String = "both"
@export_enum("left", "right", "both") var pad_beam_3: String = "both"
@export_enum("left", "right", "both") var pad_beam_4: String = "both"
