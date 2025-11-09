extends Node2D

@onready var lefttouchpad = $LeftTouchPad
@onready var righttouchpad = $RightTouchPad
@onready var snare = $Snare

var original_scale := Vector2(0.441, 0.441)
var pressed_scale := Vector2(0.398, 0.398)

var is_enabled: bool = true  # 🔹 this controls whether pads can be pressed

func _ready() -> void:
	original_scale = lefttouchpad.scale

# 🔹 Function to enable or disable pads
func set_enabled(active: bool):
	is_enabled = active
	# Slightly dim when disabled

func _on_left_touch_pad_pressed() -> void:
	if not is_enabled:
		return
	snare.play()
	lefttouchpad.scale = pressed_scale

func _on_left_touch_pad_released() -> void:
	if not is_enabled:
		return
	lefttouchpad.scale = original_scale

func _on_right_touch_pad_pressed() -> void:
	if not is_enabled:
		return
	snare.play()
	righttouchpad.scale = pressed_scale

func _on_right_touch_pad_released() -> void:
	if not is_enabled:
		return
	righttouchpad.scale = original_scale
