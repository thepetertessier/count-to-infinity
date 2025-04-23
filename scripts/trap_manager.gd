extends Node2D

@onready var player_cursor: PlayerCursor = %PlayerCursor
@onready var day_lighter_timer: Panel = %DayLighterTimer
@onready var sfx_manager: SFXManager = %SFXManager

const invincibility_duration := 1
const TIME_PENALTY = preload("res://scenes/time_penalty.tscn")

var invincible := false
var trap_players: Dictionary[Trap, AudioStreamPlayer] = {}

func _ready() -> void:
	for trap in get_traps():
		trap.trap_entered.connect(_on_trap_collision.bind(trap))
		trap_players[trap] = sfx_manager.make_new_player(trap.hit_sfx)

func get_traps() -> Array[Trap]:
	# For now, just the fire trap
	return [$FireTrap]

func _on_trap_collision(trap: Trap):
	if invincible:
		return
	invincible = true
	hurt_player_with_trap(trap)
	await get_tree().create_timer(invincibility_duration).timeout
	invincible = false

func hurt_player_with_trap(trap: Trap):
	trap_players[trap].play(0.2)
	
	var visual_time_penalty: Node2D = TIME_PENALTY.instantiate()
	add_child(visual_time_penalty)
	visual_time_penalty.position = player_cursor.position
	
	day_lighter_timer.reduce_seconds_remaining(5)
