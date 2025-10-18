extends Node2D

@export var spacing: float = 20.0
@export var wraparound_enabled: bool = false
@export var wraparound_radius: float = 300.0
@export var wraparound_width: float = 50.0

@export_range(0.0, 1.0) var opacity_strength: float = 0.35
@export_range(0.0, 1.0) var scale_strength: float = 0.25
@export_range(0.01, 0.99, 0.01) var scale_min: float = 0.1

@export var smoothing_speed: float = 6.5
@export var follow_button_focus: bool = true
@export var position_offset_node: Control
@export var up_button: Button
@export var down_button: Button

var dragging := false
var last_mouse_pos := Vector2.ZERO
var velocity := 0.0
var released := false
var swipe_active := false

var queued_print_index := -1
var last_known_global_index := -1

# 🔹 Property directly tied to GameState.notes_index
var selected_index: int:
	get:
		return GameState.notes_index if Engine.is_editor_hint() == false else 0
	set(value):
		if position_offset_node:
			GameState.notes_index = clamp(value, 0, position_offset_node.get_child_count() - 1)
		else:
			GameState.notes_index = value


func _ready():
	if position_offset_node:
		for child in position_offset_node.get_children():
			if child.has_signal("pressed") and not child.is_connected("pressed", Callable(self, "_on_button_pressed")):
				child.connect("pressed", Callable(self, "_on_button_pressed").bind(child))

		_apply_module_grade_locks() # Initialize button locks

	if up_button:
		up_button.connect("pressed", Callable(self, "_up"))
	if down_button:
		down_button.connect("pressed", Callable(self, "_down"))


# 🔹 Lock buttons for lessons 11–25 based on GameState.module_grades
func _apply_module_grade_locks():
	if !position_offset_node or GameState.module_grades.size() < 25:
		return

	for i in range(position_offset_node.get_child_count()):
		var lesson_index = i + 10 # since we start checking from lesson 11
		var child = position_offset_node.get_child(i)

		if child is TextureButton or child is Button:
			if lesson_index < GameState.module_grades.size():
				var grade = str(GameState.module_grades[lesson_index])
				child.disabled = (grade == "N/A")
			else:
				child.disabled = false


func _on_button_pressed(button: Control):
	if button.get_index() == selected_index:
		selected_index = button.get_index()
		queued_print_index = button.get_index()


# 🔹 Temporarily disable/enable all buttons (used during scrolling)
func _set_children_disabled(state: bool):
	if position_offset_node:
		for child in position_offset_node.get_children():
			if child is TextureButton or child is Button:
				child.disabled = state


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				released = false
				last_mouse_pos = event.position
				velocity = 0.0
				swipe_active = false

				if position_offset_node:
					for child in position_offset_node.get_children():
						if child.has_focus():
							child.release_focus()

				# Cancel any pressed buttons on start
				for child in position_offset_node.get_children():
					if child is TextureButton:
						child.set_pressed(false)
			else:
				# Mouse released
				if dragging:
					dragging = false
					released = true
					if swipe_active:
						_apply_module_grade_locks() # ✅ Restore lock states after swipe
					swipe_active = false

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position_offset_node.position.y += delta.y
		velocity = delta.y
		last_mouse_pos = event.position

		# 🔹 Detect swipe motion → disable buttons temporarily
		if abs(delta.y) > 5:
			if not swipe_active:
				swipe_active = true
				_set_children_disabled(true)
			for child in position_offset_node.get_children():
				if child is TextureButton and child.button_pressed:
					child.set_pressed(false)


func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return

	# Sync global index
	if GameState.notes_index != last_known_global_index:
		selected_index = GameState.notes_index
		last_known_global_index = GameState.notes_index

	selected_index = clamp(selected_index, 0, position_offset_node.get_child_count() - 1)

	# Layout children vertically
	var y := 0.0
	for i in position_offset_node.get_children():
		i.pivot_offset = i.size / 2.0
		i.position = Vector2(-i.size.x / 2.0, y)
		y += i.size.y + spacing

	# Focus tracking
	if follow_button_focus:
		for i in position_offset_node.get_children():
			if i.has_focus():
				selected_index = i.get_index()
				break

	# Smooth scroll
	if !dragging:
		var target_item = position_offset_node.get_child(selected_index)
		var target_y = -(target_item.position.y + target_item.size.y / 2.0 - get_viewport_rect().size.y / 2.0)
		position_offset_node.position.y = lerp(position_offset_node.position.y, target_y, smoothing_speed * delta)

	# Snap on release
	if released:
		released = false
		var center_y = get_viewport_rect().size.y / 2.0
		var closest_index := 0
		var smallest_dist := INF

		for i in position_offset_node.get_children():
			var item_center_y = position_offset_node.position.y + i.position.y + i.size.y / 2.0
			var dist = abs(center_y - item_center_y)
			if dist < smallest_dist:
				smallest_dist = dist
				closest_index = i.get_index()

		selected_index = closest_index
		last_known_global_index = selected_index
		_apply_module_grade_locks() # ✅ Reapply locks

	# Visual updates
	var center_y := get_viewport_rect().size.y / 2.0
	for i in position_offset_node.get_children():
		var item_center_y = position_offset_node.position.y + i.position.y + i.size.y / 2.0
		var pixel_dist = abs(center_y - item_center_y)
		var normalized = clamp(pixel_dist / (get_viewport_rect().size.y / 2.0), 0.0, 1.0)

		i.scale = Vector2.ONE * clamp(1.0 - scale_strength * normalized, scale_min, 1.0)
		i.modulate.a = clamp(1.0 - opacity_strength * normalized, 0.0, 1.0)

		if i.get_index() == selected_index:
			i.z_index = 1
			i.mouse_filter = Control.MOUSE_FILTER_STOP
			i.focus_mode = Control.FOCUS_ALL
		else:
			i.z_index = -abs(i.get_index() - selected_index)
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE
			i.focus_mode = Control.FOCUS_NONE


func _up():
	selected_index -= 1
	last_known_global_index = selected_index
	_apply_module_grade_locks()


func _down():
	selected_index += 1
	last_known_global_index = selected_index
	_apply_module_grade_locks()
