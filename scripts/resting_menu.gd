extends Control

@export var stats: PlayerStats

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var lifetime_grain_count_label = get_node("GrainCountContainer/LifetimeGrainCount")
	lifetime_grain_count_label.text = str(stats.lifetime_grain_count)
	#ResourceSaver.save(stats, "res://resources/test_player_stats.tres")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
