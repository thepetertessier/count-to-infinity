class_name Trap
extends Node2D

signal trap_entered

@export var hit_sfx: AudioStream

@onready var area_2d: Area2D = $Area2D

func _on_area_2d_body_entered(body: Node2D) -> void:
	trap_entered.emit()
