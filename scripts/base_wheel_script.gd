extends Node2D

@export var stage_num :int = 1
@export var grain_count_across_run :int = 0
@export var grain_count_min: int = 10
@export var grain_count_max: int = 20
@export var seconds_until_sunrise: int = 60
@export var run_total_seconds: int = 60

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")

func returnToGame():
	
	var next_stage = preload("res://scenes/base_grain_collection_stage.tscn").instantiate()
	
	next_stage.stage_num = stage_num
	next_stage.grain_count_across_run = grain_count_across_run
	next_stage.grain_count_min = grain_count_min
	next_stage.grain_count_max = grain_count_max
	next_stage.seconds_until_sunrise = seconds_until_sunrise
	next_stage.run_total_seconds = run_total_seconds
	
	SceneSwitcher.goto_scene(BASE_GRAIN_COLLECTION_STAGE)
