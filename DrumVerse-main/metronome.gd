extends Node2D

signal beat_tick

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var tick_sound: AudioStreamPlayer2D = $TickSound

var bpm: float = 60.0
var timer: Timer
var loop_counter: int = 0
var max_loops: int = 4
var mode: String = "practice"

func _ready() -> void:
	print("Metronome ready")
	timer = Timer.new()
	timer.one_shot = false
	timer.autostart = false
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func start(bpm_value, mode_value: String = "practice") -> void:
	bpm = float(bpm_value)
	mode = mode_value
	loop_counter = 0

	# how long one bar is (your audio length for 4 ticks)
	var bar_duration = 240.0 / bpm   # 240 / 60 = 4 sec, 240 / 120 = 2 sec, etc.

	# adjust fps so 96 frames always fit in one bar
	var fps = sprite.sprite_frames.get_frame_count("metronome") / bar_duration
	sprite.sprite_frames.set_animation_speed("metronome", fps)

	# play the animation and sound together
	sprite.play("metronome")
	tick_sound.play()

	# start the timer for per-beat ticks
	timer.wait_time = 60.0 / bpm
	timer.start()

	print("Metronome started with BPM:", bpm, " | FPS:", fps)

func _on_timer_timeout() -> void:
	emit_signal("beat_tick")
	loop_counter += 1

	if mode == "practice" and loop_counter >= max_loops:
		print("Restarting bar in Practice Mode")
		loop_counter = 0

func stop() -> void:
	if timer:
		timer.stop()
	if tick_sound and tick_sound.playing:
		tick_sound.stop()
	if sprite and sprite.is_playing():
		sprite.stop()
