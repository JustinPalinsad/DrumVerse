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
@export var left_button: Button
@export var right_button: Button

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
		_apply_module_grade_locks() # 🔹 Initialize locked buttons based on grades

	if left_button:
		left_button.connect("pressed", Callable(self, "_left"))
	if right_button:
		right_button.connect("pressed", Callable(self, "_right"))


# 🔹 Reapply GameState.module_grades locks after swipe ends
func _apply_module_grade_locks():
	if !position_offset_node:
		return

	for i in range(position_offset_node.get_child_count()):
		var child = position_offset_node.get_child(i)
		if child is TextureButton or child is Button:
			if i > 1 and i < GameState.module_grades.size():
				if str(GameState.module_grades[i]) == "N/A":
					child.disabled = true
				else:
					child.disabled = false
			else:
				child.disabled = false


func _on_button_pressed(button: Control):
	if button.get_index() == selected_index:
		selected_index = button.get_index()
		queued_print_index = button.get_index()


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
						_apply_module_grade_locks()
					swipe_active = false

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position_offset_node.position.x += delta.x
		velocity = delta.x
		last_mouse_pos = event.position

		# 🔹 Detect horizontal swipe, temporarily disable buttons
		if abs(delta.x) > 5:
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

	# Layout children horizontally
	var x := 0.0
	for i in position_offset_node.get_children():
		i.pivot_offset = i.size / 2.0
		i.position = Vector2(x, -i.size.y / 2.0)
		x += i.size.x + spacing

	# Focus tracking
	if follow_button_focus:
		for i in position_offset_node.get_children():
			if i.has_focus():
				selected_index = i.get_index()
				break

	# Smooth scroll
	if !dragging:
		var target_item = position_offset_node.get_child(selected_index)
		var target_x = -(target_item.position.x + target_item.size.x / 2.0 - get_viewport_rect().size.x / 2.0)
		position_offset_node.position.x = lerp(position_offset_node.position.x, target_x, smoothing_speed * delta)

	# Snap on release
	if released:
		released = false
		var center_x = get_viewport_rect().size.x / 2.0
		var closest_index := 0
		var smallest_dist := INF

		for i in position_offset_node.get_children():
			var item_center_x = position_offset_node.position.x + i.position.x + i.size.x / 2.0
			var dist = abs(center_x - item_center_x)
			if dist < smallest_dist:
				smallest_dist = dist
				closest_index = i.get_index()

		selected_index = closest_index
		last_known_global_index = selected_index
		_apply_module_grade_locks()

	# Visual updates
	var center_x := get_viewport_rect().size.x / 2.0
	for i in position_offset_node.get_children():
		var item_center_x = position_offset_node.position.x + i.position.x + i.size.x / 2.0
		var pixel_dist = abs(center_x - item_center_x)
		var normalized = clamp(pixel_dist / (get_viewport_rect().size.x / 2.0), 0.0, 1.0)

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


func _left():
	selected_index -= 1
	last_known_global_index = selected_index
	_apply_module_grade_locks()


func _right():
	selected_index += 1
	last_known_global_index = selected_index
	_apply_module_grade_locks()
