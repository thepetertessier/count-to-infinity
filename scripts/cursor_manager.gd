extends Node

const VAMPIRE_HAND = preload("res://assets/images/vampire_hand.png")

func _ready() -> void:
	Input.set_custom_mouse_cursor(VAMPIRE_HAND, 0, Vector2(13,0))
