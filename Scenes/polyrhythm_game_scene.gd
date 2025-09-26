extends Node2D


func _ready() -> void:
	$MovingCircleTop/TopBallAnim.play("animation w sound_top")
	$MovingCircleBottom/BottomBallAnim.play("animation w sound_2")
