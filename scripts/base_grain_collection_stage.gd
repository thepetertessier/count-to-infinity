extends Control

@export var stage_num := 1
@export var grain_count_across_run := 0
@export var grain_scene: PackedScene
@export var grain_count_min: int = 10
@export var grain_count_max: int = 20
@export var seconds_until_sunrise: int = 60
@export var run_total_seconds: int = 60

@onready var grain_manager: Node2D = %GrainManager
@onready var stage_label: Label = %StageLabel
@onready var day_lighter_timer: Panel = %DayLighterTimer

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")
const RESTING_MENU = preload("res://scenes/resting_menu.tscn")

func _ready() -> void:
	stage_label.text = "Stage: " + str(stage_num)
	grain_manager.set_stage(grain_scene, grain_count_min, grain_count_max, grain_count_across_run)
	day_lighter_timer.start_countdown(seconds_until_sunrise, run_total_seconds)


func load_resting_menu(grain_count_across_run):
	SceneSwitcher.goto_scene_from_path("res://scenes/resting_menu.tscn")

func load_next_stage(run_grain_count, seconds_remaining):
	var next_stage = BASE_GRAIN_COLLECTION_STAGE.instantiate()
	
	next_stage.stage_num = stage_num + 1
	next_stage.grain_count_across_run = run_grain_count
	next_stage.grain_count_min = int(grain_count_min * 1.5)
	next_stage.grain_count_max = grain_count_min * 2
	next_stage.seconds_until_sunrise = seconds_remaining
	next_stage.run_total_seconds = run_total_seconds
	
	SceneSwitcher.goto_node(next_stage)
