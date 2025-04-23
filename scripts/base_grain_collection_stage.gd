extends Control

@export var stage_num :int = 1
@export var grain_count_across_run := 0
@export var grain_scene: PackedScene
@export var grain_count_min: int = 10
@export var seconds_until_sunrise: int = 30
@export var run_total_seconds: int = 30
@export var history_resource: BackgroundHistory
@export var stats: PlayerStats

@onready var grain_manager: Node2D = %GrainManager
@onready var stage_label: Label = %StageLabel
@onready var day_lighter_timer: Panel = %DayLighterTimer
@onready var player_cursor: PlayerCursor = %PlayerCursor

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")
const RESTING_MENU = preload("res://scenes/resting_menu.tscn")
const backdrop_dir := "res://assets/images/stage_backdrops"
const stats_path := "res://resources/test_player_stats.tres"

func _ready() -> void:
	randomize()
	randomize_background()
	set_values_from_stats()
	stage_label.text = "Stage: " + str(stage_num)
	var grain_count_max = int(grain_count_min * 1.5)
	grain_manager.set_stats(stats.click_power, stats.auto_collect_rate)
	grain_manager.set_stage(grain_scene, grain_count_min, grain_count_max, grain_count_across_run)
	player_cursor.get_hit_box().area_entered.connect(grain_manager._on_area_entered)
	player_cursor.get_hit_box().area_exited.connect(grain_manager._on_area_exited)
	day_lighter_timer.start_countdown(seconds_until_sunrise, run_total_seconds)

func set_values_from_stats() -> void:
	player_cursor.click_radius = stats.click_radius

func load_resting_menu(grain_count_across_run):
	stats.lifetime_grain_count += grain_count_across_run
	ResourceSaver.save(stats, stats_path)
	SceneSwitcher.goto_scene_from_path("res://scenes/resting_menu.tscn")

func load_next_blood_reward(run_grain_count, seconds_remaining):	
	SceneSwitcher.load_next_blood_reward(
		run_total_seconds,
		int(grain_count_min * 1.5),
		stage_num + 1,
		run_grain_count,
		seconds_remaining
	)

func randomize_background() -> void:
	var dir_access = DirAccess.open(backdrop_dir)
	if not dir_access:
		push_error("Cannot access directory: %s" % backdrop_dir)
		return

	# Gather all PNG files
	dir_access.list_dir_begin()
	var file_name: String = dir_access.get_next()
	var candidates: Array[String] = []
	while file_name != "":
		if not dir_access.current_is_dir() and file_name.to_lower().ends_with(".png"):
			candidates.append(file_name)
		file_name = dir_access.get_next()
	dir_access.list_dir_end()

	# Filter out the recent history
	var available: Array[String] = []
	for f in candidates:
		if not history_resource.contains(f):
			available.append(f)

	# If all are filtered out, allow any
	if available.is_empty():
		available = candidates.duplicate()

	# Pick a random file
	var choice = available[randi() % available.size()]
	var tex: Texture2D = load(backdrop_dir + "/" + choice)
	if tex:
		$Background.texture = tex
		history_resource.add(choice)
	else:
		push_error("Failed to load texture: %s" % choice)
