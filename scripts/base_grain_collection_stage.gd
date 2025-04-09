extends Control

@export var stage_num := 1
@export var grain_count_across_run := 0
@export var grain_scene: PackedScene         # Drag your Rice.tscn into this field.
@export var grain_count_min: int = 10       # Minimum number of grains to generate.
@export var grain_count_max: int = 20       # Maximum number of grains to generate.

@onready var grain_manager: Node2D = %GrainManager
@onready var stage_label: Label = %StageLabel

func _ready() -> void:
	stage_label.text = "Stage: " + str(stage_num)
	grain_manager.set_stage(grain_scene, grain_count_min, grain_count_max, grain_count_across_run)
