extends Control

@export var stats: PlayerStats

const BASE_GRAIN_COLLECTION_STAGE = preload("res://scenes/base_grain_collection_stage.tscn")
const stats_path := "res://resources/test_player_stats.tres"

# tracks the current upgrade selected and its cost
var upgrade_selected
var upgrade_cost

# upgrade increments
@export var daylight_timer_upgrade_increment = 10
@export var auto_fingers_upgrade_increment = 1
@export var powerful_fingers_upgrade_increment = 1
@export var click_radius_scale = 2
@export var upgrade_cost_multiplier = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Uncomment if you want to reset the player stats:
	#reset_player_stats()
	
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


func reset_player_stats() -> void:
	stats.lifetime_grain_count = 0
	stats.blood = 0
	stats.click_power = 1
	stats.click_radius = 1
	stats.auto_collect_rate = 0
	stats.daylight_timer = 60
	stats.long_fingers_level = 1
	stats.powerful_fingers_level = 1
	stats.auto_fingers_level = 1
	stats.speed_demon_level = 1
	
	ResourceSaver.save(stats, stats_path)


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
	
	set_upgrade_menu(upgrade)
		
	$UpgradeMenu.show()


func _on_close_menu_pressed() -> void:
	$UpgradeMenu.hide()


func _on_upgrade_button_pressed() -> void:
	# check if user has enough blood
	if stats.blood >= upgrade_cost:
		stats.blood -= upgrade_cost
		
		# upgrade accordingly
		if upgrade_selected == "speed-demon":
			stats.speed_demon_level += 1
			stats.daylight_timer += daylight_timer_upgrade_increment
		elif upgrade_selected == "auto-fingers":
			stats.auto_fingers_level += 1
			stats.auto_collect_rate += auto_fingers_upgrade_increment
		elif upgrade_selected == "powerful-fingers":
			stats.powerful_fingers_level += 1
			stats.click_power += powerful_fingers_upgrade_increment
		elif upgrade_selected == "long-fingers":
			stats.long_fingers_level += 1
			stats.click_radius = click_radius_scale * sqrt(stats.long_fingers_level)
			
	# set upgrade menu display and upgrade cost
	set_upgrade_menu(upgrade_selected)
	
	# updates the stats resource accordingly
	ResourceSaver.save(stats, stats_path)
	
	# updates blood count
	var blood_count_label = get_node("BloodCountContainer/BloodCount")
	blood_count_label.text = str(stats.blood) + " ml." 
	
	
func set_upgrade_menu(upgrade):		
	if upgrade == "speed-demon":
		set_menu_speed_demon()
	elif upgrade == "auto-fingers":
		set_menu_auto_fingers()
	elif upgrade == "powerful-fingers":
		set_menu_powerful_fingers()
	elif upgrade == "long-fingers":
		set_menu_long_fingers()
		
	# update cost label after setting upgrade cost and rest of menu
	var blood_cost_label = get_node("UpgradeMenu/BloodCostContainer/BloodCost")
	blood_cost_label.text = str(upgrade_cost)
	

func _on_new_run_btn_pressed() -> void:
	var total_power = stats.auto_fingers_level + stats.speed_demon_level + stats.long_fingers_level + stats.powerful_fingers_level - 4
	var adjusted_grain_count = 10 + total_power * 1
	SceneSwitcher.load_next_stage(stats.daylight_timer, adjusted_grain_count)
	
	
func set_menu_speed_demon():
	set_upgrade_image("res://assets/images/daylight_timer_upgrade_img.png")
	set_upgrade_desc("Upgrade to increase the daylight timer!")
	set_stat_labels("Current: " + str(stats.daylight_timer) + "s", "Next: " + str(stats.daylight_timer + daylight_timer_upgrade_increment) + "s")
	set_upgrade_name_and_level("Speed Demon - Lvl" + str(stats.speed_demon_level))
	
	set_upgrade_cost(stats.speed_demon_level)
	
	
func set_menu_auto_fingers():
	set_upgrade_image("res://assets/images/autocollect_img.png")
	set_upgrade_desc("Upgrade to autocollect grains in the click radius!")
	set_stat_labels("Current Rate: " + str(stats.auto_collect_rate), "Next Rate: " + str(stats.auto_collect_rate + auto_fingers_upgrade_increment))
	set_upgrade_name_and_level("Auto-Fingers - Lvl" + str(stats.auto_fingers_level))
	
	set_upgrade_cost(stats.auto_fingers_level)
	
	
func set_menu_powerful_fingers():
	set_upgrade_image("res://assets/images/powerful_fingers_img.png")
	set_upgrade_desc("Upgrade to collect more grains with each click!")
	set_stat_labels("Current Click Power: " + str(stats.click_power), "Next Click Power: " + str(stats.click_power + powerful_fingers_upgrade_increment))
	set_upgrade_name_and_level("Powerful Fingers - Lvl" + str(stats.powerful_fingers_level))
		
	set_upgrade_cost(stats.powerful_fingers_level)
	
	
func set_menu_long_fingers():
	set_upgrade_image("res://assets/images/click_radius_menu_img.png")
	set_upgrade_desc("Upgrade to increase your click radius to get more grains!")
	# set upgrade info text
	var current_radius_rounded = snapped(click_radius_scale * sqrt(stats.long_fingers_level), 0.01)
	var next_radius_rounded = snapped(click_radius_scale * sqrt(stats.long_fingers_level + 1), 0.01)
	set_stat_labels("Current Radius: " + str(current_radius_rounded), "Next Radius: " + str(next_radius_rounded))
	set_upgrade_name_and_level("Long Fingers - Lvl" + str(stats.long_fingers_level))
		
	set_upgrade_cost(stats.long_fingers_level)
	
	
func set_upgrade_image(path):
	var upgrade_texture_rect = get_node("UpgradeMenu/UpgradeImage")
	upgrade_texture_rect.texture = load(path)
	
	
func set_upgrade_desc(text):
	var upgrade_desc_label = get_node("UpgradeMenu/UpgradeDesc")
	upgrade_desc_label.text = text
	
	
func set_upgrade_name_and_level(text):
	var upgrade_name_label = get_node("UpgradeMenu/UpgradeName")
	upgrade_name_label.text = text
	
	
func set_upgrade_cost(level):
	upgrade_cost = upgrade_cost_multiplier * level
	
	
func set_stat_labels(cur_str, next_str):
	var cur_stat_label = get_node("UpgradeMenu/CurStat")
	var new_stat_label = get_node("UpgradeMenu/NewStat")
	
	cur_stat_label.text = cur_str
	new_stat_label.text = next_str
	
