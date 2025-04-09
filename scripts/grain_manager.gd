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

func _ready():
	randomize()

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
	
	# Connect the signal from the grain when clicked.
	grain.clicked.connect(_on_grain_collected.bind(grain))
	grain.mouse_entered.connect(audio_manager.play_hover)

# Callback for when a grain is clicked.
func _on_grain_collected(grain):
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

# Called when the stage is complete.
func stage_complete():
	audio_manager.play_stage_complete()
	grain_count_label.big_center_text("Stage Complete!")
