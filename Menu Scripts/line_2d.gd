extends Line2D

@export var length := 20

func _ready() -> void:
	# Start with a single point at the parent's initial position
	clear_points()
	add_point(get_parent().global_position)

func _process(_delta: float) -> void:
	if not get_parent():
		return

	# Get the parent’s global position
	var parent_pos = get_parent().global_position

	# Add the new point
	add_point(parent_pos)

	# Limit the number of points to maintain a consistent trail length
	while get_point_count() > length:
		remove_point(0)

	# Optional: smooth trail by adjusting width along its length
	width_curve = Curve.new()
	width_curve.add_point(Vector2(0, 1))
	width_curve.add_point(Vector2(1, 0))
