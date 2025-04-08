extends Control

@export var grain_scene: PackedScene         # Drag your Rice.tscn into this field.
@export var grain_count_min: int = 10       # Minimum number of grains to generate.
@export var grain_count_max: int = 20       # Maximum number of grains to generate.
@export var screen_margin: float = 50.0     # Margin to avoid spawning too close to edges.

@onready var grain_manager: Node2D = $GrainManager

func _ready() -> void:
	grain_manager.set_stage(grain_scene, grain_count_min, grain_count_max, screen_margin)
