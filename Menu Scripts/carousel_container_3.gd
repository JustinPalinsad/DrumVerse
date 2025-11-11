@tool
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

# 🔥 Swipe detection threshold
@export var swipe_threshold: float = 10.0
var drag_accumulated := 0.0
var swiping := false  # true = ignore button presses

var dragging := false
var last_mouse_pos := Vector2.ZERO
var velocity := 0.0
var released := false

var queued_print_index := -1
var last_known_global_index := -1

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

	if up_button:
		up_button.connect("pressed", Callable(self, "_up"))
	if down_button:
		down_button.connect("pressed", Callable(self, "_down"))


func _on_button_pressed(button: Control):
	if button.get_index() == selected_index:
		selected_index = button.get_index()
		queued_print_index = button.get_index()


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				released = false
				last_mouse_pos = event.position
				velocity = 0.0
				drag_accumulated = 0.0   # 🔥 reset swipe tracking
				swiping = false          # 🔥 reset swipe flag
			else:
				# Mouse / touch released
				dragging = false
				released = true

				# Determine if we should treat this as a swipe release:
				var was_swipe := swiping or (drag_accumulated > swipe_threshold)

				if was_swipe:
					# 🔥 If it was a swipe, forcibly clear any pressed state and focus
					for c in position_offset_node.get_children():
						# clear pressed states (some Godot versions expose one or the other)
						if c is BaseButton:
							# try both in case one exists in this runtime
							# set_pressed may exist for toggle-like buttons; set_pressed_no_signal prevents signals
							if "set_pressed_no_signal" in c:
								# call safely
								c.set_pressed_no_signal(false)
							if "set_pressed" in c:
								c.set_pressed(false)
							c.release_focus()
						# ensure the child isn't clickable for the remainder of this frame;
						# _process will restore correct mouse_filter when not swiping
						c.mouse_filter = Control.MOUSE_FILTER_IGNORE

					# reset swipe tracking
					swiping = false
					drag_accumulated = 0.0
				else:
					# Not considered a swipe — user intended a click/tap.
					# We'll allow normal button behavior; nothing special here.
					pass

	elif event is InputEventMouseMotion and dragging:
		var delta = event.position - last_mouse_pos
		position_offset_node.position.y += delta.y
		velocity = delta.y
		last_mouse_pos = event.position

		# 🔥 Detect swipe motion
		drag_accumulated += abs(delta.y)
		if drag_accumulated > swipe_threshold and !swiping:
			swiping = true
			# 🔥 Disable clicking and remove pressed textures immediately
			for c in position_offset_node.get_children():
				c.mouse_filter = Control.MOUSE_FILTER_IGNORE
				if c is BaseButton:
					# try both methods to clear pressed state
					if "set_pressed_no_signal" in c:
						c.set_pressed_no_signal(false)
					if "set_pressed" in c:
						c.set_pressed(false)
					c.release_focus()


func _process(delta: float) -> void:
	if !position_offset_node or position_offset_node.get_child_count() == 0:
		return

	if GameState.notes_index != last_known_global_index:
		selected_index = GameState.notes_index
		last_known_global_index = GameState.notes_index

	selected_index = clamp(selected_index, 0, position_offset_node.get_child_count() - 1)

	var y := 0.0
	for i in position_offset_node.get_children():
		i.pivot_offset = i.size / 2.0
		i.position = Vector2(-i.size.x / 2.0, y)
		y += i.size.y + spacing

	if follow_button_focus:
		for i in position_offset_node.get_children():
			if i.has_focus():
				selected_index = i.get_index()
				break

	if !dragging:
		var target_item = position_offset_node.get_child(selected_index)
		var target_y = -(target_item.position.y + target_item.size.y / 2.0 - get_viewport_rect().size.y / 2.0)
		position_offset_node.position.y = lerp(position_offset_node.position.y, target_y, smoothing_speed * delta)

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

	var center_y := get_viewport_rect().size.y / 2.0
	for i in position_offset_node.get_children():
		var item_center_y = position_offset_node.position.y + i.position.y + i.size.y / 2.0
		var pixel_dist = abs(center_y - item_center_y)
		var normalized = clamp(pixel_dist / (get_viewport_rect().size.y / 2.0), 0.0, 1.0)

		i.scale = Vector2.ONE * clamp(1.0 - scale_strength * normalized, scale_min, 1.0)
		i.modulate.a = clamp(1.0 - opacity_strength * normalized, 0.0, 1.0)

		# 🔥 If we are currently swiping, keep clicks disabled for safety
		if swiping:
			i.mouse_filter = Control.MOUSE_FILTER_IGNORE
			continue

		# ✅ Normal click state behavior (restore correct filters)
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


func _down():
	selected_index += 1
	last_known_global_index = selected_index
