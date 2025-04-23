extends TextureButton

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")

@export var total_grains: int = 0
@export var collected_count: int = 0

@export var nodeAddBlood : Node
@onready var baseScene: Control = $".."
@export var stats: PlayerStats


func _on_spun() -> void:
	print("spun")
	show()

func _on_pressed() -> void:
	
	stats.blood += nodeAddBlood.addblood
	ResourceSaver.save(stats, "res://resources/test_player_stats.tres")
	
	self.hide()
	
	# show blood count
	var blood_count = get_node("../BloodCount")
	blood_count.text = "+" + str(nodeAddBlood.addblood)
	blood_count.show()
	
	# play blood splatter sound
	var blood_splatter = get_node("../BloodSplatter")
	blood_splatter.play()
	await blood_splatter.finished
	
	baseScene.returnToGame()
