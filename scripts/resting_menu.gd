extends Control

@export var stats: PlayerStats

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")

var upgrade_selected
var upgrade_cost

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Reset after being set by run
	Input.set_custom_mouse_cursor(null)

	# sample lifetime grain count
	var lifetime_grain_count_label = get_node("GrainCountContainer/LifetimeGrainCount")
	lifetime_grain_count_label.text = str(stats.lifetime_grain_count)
	
	# sample blood count
	var blood_count_label = get_node("BloodCountContainer/BloodCount")
	blood_count_label.text = str(stats.blood) + " ml."
	
	# start background music
	$Music.play()
	
	# hide upgrade menu
	$UpgradeMenu.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_speed_demon_upgrade_btn_pressed() -> void:
	open_upgrade_menu("speed-demon")


func _on_auto_fingers_upgrade_btn_pressed() -> void:
	open_upgrade_menu("auto-fingers")


func _on_powerful_fingers_upgrade_btn_pressed() -> void:
	open_upgrade_menu("powerful-fingers")


func _on_long_fingers_upgrade_btn_pressed() -> void:
	open_upgrade_menu("long-fingers")
	
func open_upgrade_menu(upgrade):
	# tracks which upgrade is open in the menu
	upgrade_selected = upgrade
	
	set_upgrade_name_and_cost(upgrade)
		
	$UpgradeMenu.show()


func _on_close_menu_pressed() -> void:
	$UpgradeMenu.hide()


func _on_upgrade_button_pressed() -> void:
	if stats.blood >= upgrade_cost:
		stats.blood -= upgrade_cost
		
		if upgrade_selected == "speed-demon":
			stats.speed_demon_level += 1
			stats.daylight_timer += 10
		elif upgrade_selected == "auto-fingers":
			stats.auto_fingers_level += 1
			stats.auto_collect_rate += 1
		elif upgrade_selected == "powerful-fingers":
			stats.powerful_fingers_level += 1
			stats.click_power += 1
		elif upgrade_selected == "long-fingers":
			stats.long_fingers_level += 1
			stats.click_radius = 1 * sqrt(stats.long_fingers_level)
			
	set_upgrade_name_and_cost(upgrade_selected)
	
	# updates the stats resource accordingly
	ResourceSaver.save(stats, "res://resources/test_player_stats.tres")
	
	# updates blood count
	var blood_count_label = get_node("BloodCountContainer/BloodCount")
	blood_count_label.text = str(stats.blood) + " ml." 
	
func set_upgrade_name_and_cost(upgrade):
	var upgrade_name_label = get_node("UpgradeMenu/UpgradeName")
	var blood_cost_label = get_node("UpgradeMenu/BloodCostContainer/BloodCost")
	
	if upgrade == "speed-demon":
		upgrade_name_label.text = "Speed Demon - Lvl" + str(stats.speed_demon_level)
		upgrade_cost = 200 * stats.speed_demon_level
	elif upgrade == "auto-fingers":
		upgrade_name_label.text = "Auto-Fingers - Lvl" + str(stats.auto_fingers_level)
		upgrade_cost = 200 * stats.auto_fingers_level
	elif upgrade == "powerful-fingers":
		upgrade_name_label.text = "Powerful Fingers - Lvl" + str(stats.powerful_fingers_level)
		upgrade_cost = 200 * stats.powerful_fingers_level
	elif upgrade == "long-fingers":
		upgrade_name_label.text = "Long Fingers - Lvl" + str(stats.long_fingers_level)
		upgrade_cost = 200 * stats.long_fingers_level
		
	blood_cost_label.text = str(upgrade_cost)
	

func _on_new_run_btn_pressed() -> void:
	SceneSwitcher.goto_scene(BASE_GRAIN_COLLECTION_STAGE)
