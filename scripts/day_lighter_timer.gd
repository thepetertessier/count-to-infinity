extends Panel

@onready var timer: Timer = $SecondTimer
@onready var grain_manager: Node2D = %GrainManager
@onready var day_light_timer_label: Label = $DayLightTimerLabel
@onready var sfx_manager: Node = %SFXManager
@onready var music_manager: Node = %MusicManager
@onready var grain_count_label: Label = %GrainCountLabel
@onready var sunlight_animation_player: AnimationPlayer = %SunlightAnimationPlayer
@onready var scene_manager: Node = %SceneManager

var seconds_remaining: int
var run_total_seconds: int  # For determining screen brightness

func stop():
	timer.stop()

func get_seconds_remaining():
	return seconds_remaining

func start_countdown(seconds: int, _run_total_seconds: int):
	seconds_remaining = seconds
	run_total_seconds = _run_total_seconds
	_on_second_timer_timeout()
	sunlight_animation_player.set_speed_scale(1.0 / _run_total_seconds)
	sunlight_animation_player.seek(float(seconds) / _run_total_seconds, true, true)
	sunlight_animation_player.play("sunrise")
	timer.start()

func _on_second_timer_timeout() -> void:
	seconds_remaining -= 1
	
	sunlight_animation_player
	
	var minutes = seconds_remaining / 60
	var seconds = seconds_remaining % 60
	var sec_str = str(seconds)
	if seconds < 10:
		sec_str = "0" + sec_str
	day_light_timer_label.text = str(minutes) + ":" + sec_str
	
	if seconds_remaining <= 0:
		timer.stop()
		grain_manager.visible = false
		sfx_manager.stop_pops()
		sfx_manager.play_run_over()
		grain_count_label.big_center_text("Run Over!")
		grain_count_label.z_index = 5  # Above white screen
		music_manager.fade_out(1)
		await get_tree().create_timer(2).timeout
		scene_manager.go_to_resting(grain_manager.get_grain_count_across_run())
		return

	if seconds_remaining <= 10:
		day_light_timer_label.modulate = Color.RED
		sfx_manager.play_buzzer()
	
