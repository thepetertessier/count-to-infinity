extends Node

@onready var base_grain_collection_stage: Control = $".."

func go_to_resting(grain_count_across_run):
	base_grain_collection_stage.load_resting_menu(grain_count_across_run)

func go_to_blood_reward(run_grain_count, seconds_remaining):
	# For now, go to next stage, until blood reward scene is done
	base_grain_collection_stage.load_next_stage(run_grain_count, seconds_remaining)
