extends Node2D


func _ready() -> void:
	$"Moving Circe"/MovingCircleTop/TopBallAnim.play("Top_Line")
	$"Moving Circe"/MovingCircleBottom/BottomBallAnim.play("Bottom_Line")
