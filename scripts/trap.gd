class_name Trap
extends Node2D

signal trap_entered

@export var hit_sfx: AudioStream

@onready var area_2d: Area2D = $Area2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _on_area_2d_body_entered(body: Node2D) -> void:
	trap_entered.emit()

func set_speed_scale(speed_scale: float):
	animation_player.set_speed_scale(speed_scale)
