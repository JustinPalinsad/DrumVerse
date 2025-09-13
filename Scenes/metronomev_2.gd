extends Node2D

var bpmx = 60

var bpm = bpmx/60.0

func _ready():
	$AnimationPlayer.speed_scale = bpm
	$AnimationPlayer.play("swing")
	$BPM.text = str(bpmx)
