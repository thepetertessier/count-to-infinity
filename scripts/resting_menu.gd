extends Control

@export var stats: PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# sample lifetime grain count
	var lifetime_grain_count_label = get_node("GrainCountContainer/LifetimeGrainCount")
	lifetime_grain_count_label.text = str(stats.lifetime_grain_count)
	
	# sample blood count
	var blood_count_label = get_node("BloodCountContainer/BloodCount")
	blood_count_label.text = str(stats.blood) + " ml."
	#ResourceSaver.save(stats, "res://resources/test_player_stats.tres")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
