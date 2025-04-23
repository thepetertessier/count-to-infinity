extends Node2D

@onready var player_cursor: PlayerCursor = %PlayerCursor
@onready var day_lighter_timer: Panel = %DayLighterTimer
@onready var sfx_manager: SFXManager = %SFXManager

const invincibility_duration := 1
const TIME_PENALTY = preload("res://scenes/time_penalty.tscn")
const FIRE_TRAP = preload("res://scenes/fire_trap.tscn")

var invincible := true
var trap_players: Dictionary[Trap, AudioStreamPlayer] = {}

func set_level(stage_num: int) -> void:
	randomize()
	for trap in get_traps(stage_num):
		trap.trap_entered.connect(_on_trap_collision.bind(trap))
		trap_players[trap] = sfx_manager.make_new_player(trap.hit_sfx)
	grant_invincibility()

func make_fire_trap(level: int) -> Trap:
	var fire_trap: Trap = FIRE_TRAP.instantiate()
	add_child(fire_trap)
	const trap_x := 959.0
	var trap_y := randf_range(300, 800)
	fire_trap.set_position(Vector2(trap_x, trap_y))
	var speed_scale = randf_range(0.8, 1.2) * (2.0 * level / 5.0)
	fire_trap.set_speed_scale(speed_scale)
	return fire_trap

func get_traps(level: int) -> Array[Trap]:
	# For now, just some fire traps
	var num_of_fire_traps = level - 1
	var traps: Array[Trap] = []
	for i in range(num_of_fire_traps):
		traps.append(make_fire_trap(level))
	return traps

func _on_trap_collision(trap: Trap):
	if invincible:
		return
	hurt_player_with_trap(trap)
	grant_invincibility()

func grant_invincibility():
	invincible = true
	await get_tree().create_timer(invincibility_duration).timeout
	invincible = false

func hurt_player_with_trap(trap: Trap):
	trap_players[trap].play(0.2)
	
	var visual_time_penalty: Node2D = TIME_PENALTY.instantiate()
	add_child(visual_time_penalty)
	visual_time_penalty.position = player_cursor.position
	
	day_lighter_timer.reduce_seconds_remaining(5)
