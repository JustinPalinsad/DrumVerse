extends Camera2D

var swipe_start_pos: Vector2
var swipe_threshold: float = 100.0  # Minimum distance in pixels to count as a swipe

@onready var main_menu = get_parent()  # assumes Camera2D is a child of MainMenu

func _input(event: InputEvent) -> void:
	if event is InputEventScreenTouch:
		if event.pressed:
			swipe_start_pos = event.position
		else:
			var swipe_vector = event.position - swipe_start_pos
			if abs(swipe_vector.x) > swipe_threshold and abs(swipe_vector.x) > abs(swipe_vector.y):
				if swipe_vector.x > 0:
					main_menu.change_index(-1)  # swipe right
				else:
					main_menu.change_index(1)  # swipe left
