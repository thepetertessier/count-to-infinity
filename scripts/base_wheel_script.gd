extends Control

@export var stage_num :int = 1
@export var grain_count_across_run :int = 0
@export var grain_count_min: int = 10
@export var grain_count_max: int = 20
@export var seconds_until_sunrise: int = 60
@export var run_total_seconds: int = 60

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")

func _ready():
	$EndlessWheelSpinSoundEffect.play()

func returnToGame():	
	SceneSwitcher.load_next_stage(run_total_seconds, grain_count_min, stage_num, grain_count_across_run, seconds_until_sunrise)
