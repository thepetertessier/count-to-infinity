extends Node2D

@onready var player_cursor: PlayerCursor = %PlayerCursor

const invincibility_duration := 1
const TIME_PENALTY = preload("res://scenes/time_penalty.tscn")

var invincible := false
var traps: Array[Trap] = []

func _ready() -> void:
	add_traps()
	for trap in traps:
		trap.trap_entered.connect(_on_trap_collision.bind(trap))

func add_traps():
	# For now, just the fire trap
	traps.append($FireTrap)

func _on_trap_collision(trap: Trap):
	if invincible:
		return
	invincible = true
	hurt_player_with_trap(trap)
	await get_tree().create_timer(invincibility_duration).timeout
	invincible = false

func hurt_player_with_trap(trap: Trap):
	var time_penalty: Node2D = TIME_PENALTY.instantiate()
	add_child(time_penalty)
	time_penalty.position = player_cursor.position
