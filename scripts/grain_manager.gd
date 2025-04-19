class_name GrainManager
extends Node2D

var total_grains: int = 0
var collected_count: int = 0
var grain_count_across_run: int

# Get the label node for updating UI. Adjust the path if needed.
@onready var grain_count_label: Label = %GrainCountLabel
@onready var audio_manager: Node = %SFXManager
@onready var jar: Sprite2D = $Jar
@onready var run_grain_count_label: Label = $RunGrainCountLabel
@onready var grain_spawn_area: Control = %GrainSpawnArea
@onready var scene_manager: Node = %SceneManager
@onready var day_lighter_timer: Panel = %DayLighterTimer

var click_power: int
var auto_collect_rate: float

func set_stats(_click_power: int, _auto_collect_rate: float):
	click_power = _click_power
	auto_collect_rate = _auto_collect_rate

func _ready():
	randomize()

func get_grain_count_across_run():
	return grain_count_across_run

func set_stage(grain_scene: PackedScene, grain_count_min: int, grain_count_max: int, _grain_count_across_run: int):
	grain_count_across_run = _grain_count_across_run
	total_grains = randi_range(grain_count_min, grain_count_max)
	
	# Spawn each grain.
	for i in range(total_grains):
		spawn_grain(grain_scene)
	
	update_ui()

# Function to spawn a grain in a random position.
func spawn_grain(grain_scene):
	var grain = grain_scene.instantiate()
	add_child(grain)
	var bounds := grain_spawn_area.get_rect()
	grain.position = Vector2(
		randf_range(bounds.position.x, bounds.position.x + bounds.size.x),
		randf_range(bounds.position.y, bounds.position.y + bounds.size.y)
	)
	#grain.rotatation = randf_range(-1, 1)
	grain.scale = Vector2(1, 1) * randf_range(0.8, 1.1)

func collect_grain(grain: Grain):
	grain.on_collected()
	audio_manager.play_pop()
	collected_count += 1
	grain_count_across_run += 1
	update_ui()
	
	# Animate the grain's movement to the jar
	var tween = get_tree().create_tween()
	tween.tween_property(grain, "position", jar.position, 1)
	tween.parallel().tween_property(grain, "scale", Vector2(), 1)
	tween.set_parallel(false)
	tween.tween_callback(set_run_grain_count_label.bind(grain_count_across_run))
	tween.tween_callback(audio_manager.play_collect)
	tween.tween_callback(grain.queue_free)
	tween.tween_callback(func(): if collected_count >= total_grains: stage_complete())

# Update the UI label.
func update_ui():
	grain_count_label.text = "Collected: " + str(collected_count) + " / " + str(total_grains)

func set_run_grain_count_label(amount):
	run_grain_count_label.text = "x" + str(amount)

var stage_completed = false

# Called when the stage is complete.
func stage_complete():
	if stage_completed:
		return
	stage_completed = true
	
	day_lighter_timer.stop()
	
	var seconds_remaining = day_lighter_timer.get_seconds_remaining()
	audio_manager.play_stage_complete()
	grain_count_label.big_center_text("Stage Complete!")
	await get_tree().create_timer(2).timeout
	scene_manager.go_to_blood_reward(grain_count_across_run, seconds_remaining)

## Logic for grain collection
# internals
var _grains_in_range := FastSet.new()
var _auto_accumulator: float = 0.0

func _on_area_entered(area: Area2D) -> void:
	_grains_in_range.add(area)
	audio_manager.play_hover()
	get_grain_root(area).on_entered_range()

func _on_area_exited(area: Area2D) -> void:
	_grains_in_range.remove(area)
	get_grain_root(area).on_exited_range()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_collect_grains(click_power)

func _process(delta: float) -> void:
	# accumulate fractional grains
	_auto_accumulator += auto_collect_rate * delta
	if _auto_accumulator >= 1.0:
		var to_collect = floor(_auto_accumulator)
		_collect_grains(to_collect)
		_auto_accumulator -= to_collect

func _collect_grains(amount: int) -> void:
	# pull up to `amount` grains out of _grains_in_range
	var collected := 0
	while collected < amount and _grains_in_range.size() > 0:
		var grain_area: Area2D = _grains_in_range.pop_any()
		if not is_instance_valid(grain_area):
			continue  # it may already have been freed
		var grain_root := get_grain_root(grain_area)
		collect_grain(grain_root)
		collected += 1
		
func get_grain_root(grain_area: Area2D) -> Grain:
	return grain_area.get_parent().get_parent()
