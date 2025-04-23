extends Node2D

signal clicked
signal mouse_entered

@onready var rotating_sprite: Node2D = $RotatingSprite
@onready var area_2d: Area2D = $RotatingSprite/Area2D

func _ready() -> void:
	_on_area_2d_mouse_exited()
	
func _on_area_2d_mouse_entered() -> void:
	rotating_sprite.modulate = Color.WHITE
	mouse_entered.emit()
	
func _on_area_2d_mouse_exited() -> void:
	rotating_sprite.modulate = Color.WHITE * 0.7

func _on_area_2d_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()
		disable_area_2d()

func disable_area_2d() -> void:
	area_2d.visible = false
