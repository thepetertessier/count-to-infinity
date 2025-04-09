extends Node2D

var total_grains: int = 0
var collected_count: int = 0

# Get the label node for updating UI. Adjust the path if needed.
@onready var grain_count_label: Label = %GrainCountLabel
@onready var audio_manager: Node = %AudioManager

func _ready():
	randomize()

func set_stage(grain_scene: PackedScene, grain_count_min: int, grain_count_max: int, screen_margin: Vector2):
	# Randomly decide the number of grain to spawn.
	total_grains = randi_range(grain_count_min, grain_count_max)
	
	# Spawn each grain.
	for i in range(total_grains):
		spawn_grain(grain_scene, screen_margin, i)
	
	update_ui()

# Function to spawn a grain in a random position.
func spawn_grain(grain_scene, screen_margin, index):
	var grain = grain_scene.instantiate()
	add_child(grain)
	var viewport_size = get_viewport().size
	grain.position = Vector2(
		randf_range(screen_margin.x, viewport_size.x - screen_margin.x),
		randf_range(screen_margin.y, viewport_size.y - screen_margin.y)
	)
	#grain.rotatation = randf_range(-1, 1)
	grain.scale = Vector2(1, 1) * randf_range(0.8, 1.1)
	
	# Connect the signal from the grain when clicked.
	var result = grain.clicked.connect(_on_grain_clicked.bind(index))
	print("Connection result: ", result)

# Callback for when a grain is clicked.
func _on_grain_clicked(grain_index):
	audio_manager.play_pop()
	collected_count += 1
	update_ui()
	
	# Check if all grains are collected.
	if collected_count >= total_grains:
		stage_complete()

# Update the UI label.
func update_ui():
	grain_count_label.text = "Collected: " + str(collected_count) + " / " + str(total_grains)

# Called when the stage is complete.
func stage_complete():
	grain_count_label.text = "Stage Complete!"
	# Optionally, you can implement further stage-completion logic here.
