extends Panel

@onready var timer: Timer = $SecondTimer
@onready var grain_manager: Node2D = %GrainManager
@onready var day_light_timer_label: Label = $DayLightTimerLabel
@onready var sfx_manager: Node = %SFXManager

var seconds_remaining: int
var run_total_seconds: int  # For determining screen brightness

func start_countdown(seconds: int, _run_total_seconds: int):
	seconds_remaining = seconds
	run_total_seconds = _run_total_seconds
	_on_second_timer_timeout()
	timer.start()

func _on_second_timer_timeout() -> void:
	seconds_remaining -= 1
	
	var minutes = seconds_remaining / 60
	var seconds = seconds_remaining % 60
	var sec_str = str(seconds)
	if seconds < 10:
		sec_str = "0" + sec_str
	day_light_timer_label.text = str(minutes) + ":" + sec_str
	
	if seconds_remaining <= 10:
		day_light_timer_label.modulate = Color.RED
		sfx_manager.play_buzzer()
	
	if seconds_remaining <= 0:
		timer.stop()
		grain_manager.visible = false
		print("Game Over!")
		return
