extends Control

var HitScene := preload("res://Scenes/Shared/HitEffect.tscn")
var MissScene := preload("res://Scenes/Shared/MissEffect.tscn")

# keep track of the note/area currently inside each hitbox
var top_target: Area2D = null
var bottom_target: Area2D = null

# counters
var top_play_count: int = 0
var bottom_play_count: int = 0
var max_plays: int = 4

# --- scoring ---
var total_hits: int = 0
var total_misses: int = 0
var total_attempts: int = 0

# references for readability
@onready var top_anim = $Middle_Point/HitLineTop/MovingCircleTop/TopBallAnim
@onready var bottom_anim = $Middle_Point/HitLineBottom/MovingCircleBottom/BottomBallAnim
@onready var countdown_label: Label = $CountdownLabel   # 👈 Label node for countdown

func _ready() -> void:
	# hide animations until countdown is done
	top_anim.stop()
	bottom_anim.stop()

	# connect hitbox signals
	$Middle_Point/HitLineTop/MovingCircleTop/HitArea.area_entered.connect(_on_top_area_entered)
	$Middle_Point/HitLineTop/MovingCircleTop/HitArea.area_exited.connect(_on_top_area_exited)
	$Middle_Point/HitLineBottom/MovingCircleBottom/HitArea.area_entered.connect(_on_bottom_area_entered)
	$Middle_Point/HitLineBottom/MovingCircleBottom/HitArea.area_exited.connect(_on_bottom_area_exited)

	# start countdown before game
	_start_countdown()


# --- COUNTDOWN ---
func _start_countdown() -> void:
	countdown_label.visible = true
	
	countdown_label.text = "3"
	$CountdownAudioPlayer.play()
	await get_tree().create_timer(1.0).timeout
	countdown_label.text = "2"
	$CountdownAudioPlayer.play()
	await get_tree().create_timer(1.0).timeout
	countdown_label.text = "1"
	$CountdownAudioPlayer.play()
	await get_tree().create_timer(1.0).timeout
	countdown_label.text = "Go!"
	$CountdownAudioPlayer.play()
	await get_tree().create_timer(1.0).timeout
	
	# hide the label after "Go!"
	countdown_label.visible = false
	
	# now start both animations
	_play_top_animation()
	_play_bottom_animation()


# --- ANIMATION PLAY LIMIT ---
func _play_top_animation() -> void:
	if GameState.polyrhythm_mode == "practice":
		# loop forever
		top_anim.play("Top_Line")
		await top_anim.animation_finished
		_play_top_animation()
	else:
		# challenge → limit to 4 times
		if top_play_count < max_plays:
			top_play_count += 1
			top_anim.play("Top_Line")
			await top_anim.animation_finished
			_play_top_animation()
		else:
			_check_results()


func _play_bottom_animation() -> void:
	if GameState.polyrhythm_mode == "practice":
		# loop forever
		bottom_anim.play("Bottom_Line")
		await bottom_anim.animation_finished
		_play_bottom_animation()
	else:
		# challenge → limit to 4 times
		if bottom_play_count < max_plays:
			bottom_play_count += 1
			bottom_anim.play("Bottom_Line")
			await bottom_anim.animation_finished
			_play_bottom_animation()
		else:
			_check_results()



# --- TOP HITBOX ---
func _on_top_area_entered(area: Area2D) -> void:
	top_target = area
	area.set_meta("was_hit", false)
	area.set_meta("enter_time", Time.get_ticks_msec())  # 👈 track when it entered


func _on_top_area_exited(area: Area2D) -> void:
	if top_target == area:
		var stay_time = Time.get_ticks_msec() - int(area.get_meta("enter_time"))

		# only count as miss if it stayed long enough and wasn't hit
		if stay_time > 100 and not area.get_meta("was_hit"):
			total_attempts += 1
			total_misses += 1
			print("TOP MISS (passed without hit)")
			# 👇 no spawn miss effect here anymore

		top_target = null


# --- BOTTOM HITBOX ---
func _on_bottom_area_entered(area: Area2D) -> void:
	bottom_target = area
	area.set_meta("was_hit", false)
	area.set_meta("enter_time", Time.get_ticks_msec())


func _on_bottom_area_exited(area: Area2D) -> void:
	if bottom_target == area:
		var stay_time = Time.get_ticks_msec() - int(area.get_meta("enter_time"))

		if stay_time > 100 and not area.get_meta("was_hit"):
			total_attempts += 1
			total_misses += 1
			print("BOTTOM MISS (passed without hit)")
			# 👇 no spawn miss effect here either

		bottom_target = null



# --- HELPER: activate after 1 frame ---
func _activate_note(area: Area2D) -> void:
	if is_instance_valid(area):
		area.set_meta("active", true)



func _process(delta: float) -> void:
	# check top (left_pad)
	if Input.is_action_just_pressed("left_pad"):
		total_attempts += 1
		if top_target:
			print("TOP HIT")
			total_hits += 1
			top_target.set_meta("was_hit", true)
			_spawn_hit_effect(top_target)
		else:
			print("TOP MISS (pressed outside)")
			total_misses += 1
			_spawn_miss_effect($Middle_Point/HitLineTop/MovingCircleTop/HitArea)

	if Input.is_action_just_pressed("right_pad"):
		total_attempts += 1
		if bottom_target:
			print("BOTTOM HIT")
			total_hits += 1
			bottom_target.set_meta("was_hit", true)
			_spawn_hit_effect(bottom_target)
		else:
			print("BOTTOM MISS (pressed outside)")
			total_misses += 1
			_spawn_miss_effect($Middle_Point/HitLineBottom/MovingCircleBottom/HitArea)



# --- EFFECTS ---
func _spawn_hit_effect(target: Node) -> void:
	var hit_instance = HitScene.instantiate()
	add_child(hit_instance)

	hit_instance.global_position = target.global_position
	hit_instance.z_index = 10

	# force 0.5 scale
	if hit_instance is Node2D:
		hit_instance.scale = Vector2(0.5, 0.5)
	elif hit_instance is Control:
		hit_instance.rect_scale = Vector2(0.5, 0.5)

	hit_instance.get_tree().create_timer(0.2).timeout.connect(
		func():
			if is_instance_valid(hit_instance):
				hit_instance.queue_free()
	)


func _spawn_miss_effect(area_node: Node) -> void:
	var miss_instance = MissScene.instantiate()
	add_child(miss_instance)

	miss_instance.global_position = area_node.global_position
	miss_instance.z_index = 10

	# force 0.5 scale
	if miss_instance is Node2D:
		miss_instance.scale = Vector2(0.5, 0.5)
	elif miss_instance is Control:
		miss_instance.rect_scale = Vector2(0.5, 0.5)

	miss_instance.get_tree().create_timer(0.2).timeout.connect(
		func():
			if is_instance_valid(miss_instance):
				miss_instance.queue_free()
	)


# --- RESULTS CALCULATION ---
func _check_results() -> void:
	# Only show results once both top and bottom are done
	if top_play_count >= max_plays and bottom_play_count >= max_plays:
		var hit_percentage: float = 0.0
		if total_attempts > 0:
			hit_percentage = float(total_hits) / float(total_attempts) * 100.0

		var grade: String = ""
		if hit_percentage >= 95:
			grade = "S"
		elif hit_percentage >= 85:
			grade = "A"
		elif hit_percentage >= 70:
			grade = "B"
		elif hit_percentage >= 50:
			grade = "C"
		else:
			grade = "Failed"

		print("Results -> Hits:", total_hits, " Misses:", total_misses, 
			  " Attempts:", total_attempts, " Percentage:", hit_percentage, " Grade:", grade)

		_show_results(hit_percentage, grade)


# --- SHOW RESULTS SCENE ---
func _show_results(passed_hit_percentage: float, passed_grade: String) -> void:
	var results_scene = preload("res://Sample/result_scene.tscn").instantiate()
	results_scene.total_hits = total_hits
	results_scene.total_notes = total_attempts
	results_scene.total_misses = total_misses
	results_scene.hit_percentage = passed_hit_percentage
	results_scene.grade = passed_grade
	results_scene.mode = "default"  # or whatever mode you want to pass

	get_tree().get_root().add_child(results_scene)
	hide()


func _on_back_pressed() -> void:
	await get_tree().create_timer(0.2).timeout
	get_tree().change_scene_to_file("res://Sample/sample_scene.tscn")
