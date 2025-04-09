extends Control

@export var stage_num := 1
@export var grain_count_across_run := 0
@export var grain_scene: PackedScene
@export var grain_count_min: int = 10
@export var grain_count_max: int = 20
@export var seconds_until_sunrise: int = 60
@export var run_total_second: int = 60

@onready var grain_manager: Node2D = %GrainManager
@onready var stage_label: Label = %StageLabel
@onready var day_lighter_timer: Panel = %DayLighterTimer

func _ready() -> void:
	stage_label.text = "Stage: " + str(stage_num)
	grain_manager.set_stage(grain_scene, grain_count_min, grain_count_max, grain_count_across_run)
	day_lighter_timer.start_countdown(seconds_until_sunrise, run_total_second)
