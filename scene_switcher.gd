extends Node

var current_scene = null
const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")
const SPINNER = preload("res://scenes/spinner.tscn")

func _ready():
	var root = get_tree().root
	# Using a negative index counts from the end, so this gets the last child node of `root`.
	current_scene = root.get_child(-1)
	
func goto_scene_from_path(path: String):
	var s = ResourceLoader.load(path)
	goto_scene(s)

func goto_scene(scene: PackedScene):
	var node = scene.instantiate()
	goto_node(node)

func goto_node(node: Node):
	_deferred_goto_node.call_deferred(node)

func _deferred_goto_node(node: Node):
	current_scene.free()

	# Instance the new scene.
	current_scene = node

	# Add it to the active scene, as child of root.
	get_tree().root.add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene_to_file() API.
	get_tree().current_scene = current_scene

func load_next_stage(run_total_seconds, grain_count_min := 10, stage_num := 1, run_grain_count := 0, seconds_remaining = null):
	load_next_scene(BASE_GRAIN_COLLECTION_STAGE, run_total_seconds, grain_count_min, stage_num, run_grain_count, seconds_remaining)

func load_next_blood_reward(run_total_seconds, grain_count_min := 10, stage_num := 1, run_grain_count := 0, seconds_remaining = null):
	load_next_scene(SPINNER, run_total_seconds, grain_count_min, stage_num, run_grain_count, seconds_remaining)

func load_next_scene(scene: PackedScene, run_total_seconds, grain_count_min := 10, stage_num := 1, run_grain_count := 0, seconds_remaining = null):
	var next_stage = scene.instantiate()
	
	next_stage.stage_num = stage_num
	next_stage.grain_count_across_run = run_grain_count
	next_stage.grain_count_min = grain_count_min
	next_stage.seconds_until_sunrise = run_total_seconds if seconds_remaining == null else seconds_remaining
	next_stage.run_total_seconds = run_total_seconds	
	goto_node(next_stage)
