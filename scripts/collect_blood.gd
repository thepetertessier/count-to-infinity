extends TextureButton

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")

@export var total_grains: int = 0
@export var collected_count: int = 0

@export var nodeAddBlood : Node
@export var baseScene : Node
@export var stats: PlayerStats


func _on_spun() -> void:
	var cen = Vector2(get_viewport_rect().size / 2)
	print("spun")
	self.position = Vector2(get_viewport_rect().size / 2) - self.get_size()/2 - Vector2(0,0)

func _on_pressed() -> void:
	
	stats.blood += nodeAddBlood.addblood
	ResourceSaver.save(stats, "res://resources/test_player_stats.tres")
	
	baseScene.returnToGame()
