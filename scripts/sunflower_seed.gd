extends Node2D

signal clicked

@onready var rotating_sprite: Node2D = $RotatingSprite

func _ready() -> void:
	_on_area_2d_mouse_exited()

func _on_area_2d_mouse_entered() -> void:
	rotating_sprite.modulate = Color.WHITE
	
func _on_area_2d_mouse_exited() -> void:
	rotating_sprite.modulate = Color.WHITE * 0.7

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		print("clicked!")
		clicked.emit()
		queue_free()
