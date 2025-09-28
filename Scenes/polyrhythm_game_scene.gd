extends Node2D


func _ready() -> void:
	#$Middle_Point/HitLineTop/MovingCircleTop/TopBallAnim.play("Top_Line_2")
	#$Middle_Point/HitLineBottom/MovingCircleBottom/BottomBallAnim.play("Bottom_Line_2")
	$"Moving Circe/MovingCircleTop/TopBallAnim".play("Top_Line")
	$"Moving Circe/MovingCircleBottom/BottomBallAnim".play("Bottom_Line")
