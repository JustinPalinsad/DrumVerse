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

# references for readability
@onready var top_anim = $Middle_Point/HitLineTop/MovingCircleTop/TopBallAnim
@onready var bottom_anim = $Middle_Point/HitLineBottom/MovingCircleBottom/BottomBallAnim
@onready var countdown_label: Label = $CountdownLabel   # 👈 Make sure you have a Label node named "CountdownLabel"

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
	if top_play_count < max_plays:
		top_play_count += 1
		top_anim.play("Top_Line")
		# wait until finished, then try again
		await top_anim.animation_finished
		_play_top_animation()
	else:
		print("Top animation done")


func _play_bottom_animation() -> void:
	if bottom_play_count < max_plays:
		bottom_play_count += 1
		bottom_anim.play("Bottom_Line")
		await bottom_anim.animation_finished
		_play_bottom_animation()
	else:
		print("Bottom animation done")


# --- TOP HITBOX ---
func _on_top_area_entered(area: Area2D) -> void:
	top_target = area

func _on_top_area_exited(area: Area2D) -> void:
	if top_target == area:
		top_target = null


# --- BOTTOM HITBOX ---
func _on_bottom_area_entered(area: Area2D) -> void:
	bottom_target = area

func _on_bottom_area_exited(area: Area2D) -> void:
	if bottom_target == area:
		bottom_target = null


func _process(delta: float) -> void:
	# check top (left_pad)
	if Input.is_action_just_pressed("left_pad"):
		if top_target:
			print("TOP HIT")
			_spawn_hit_effect(top_target)
		else:
			print("TOP MISS")
			_spawn_miss_effect($Middle_Point/HitLineTop/MovingCircleTop/HitArea)

	# check bottom (right_pad)
	if Input.is_action_just_pressed("right_pad"):
		if bottom_target:
			print("BOTTOM HIT")
			_spawn_hit_effect(bottom_target)
		else:
			print("BOTTOM MISS")
			_spawn_miss_effect($Middle_Point/HitLineBottom/MovingCircleBottom/HitArea)


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
