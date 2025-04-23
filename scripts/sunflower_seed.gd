extends Grain

@onready var rotating_sprite: Node2D = $RotatingSprite
@onready var area_2d: Area2D = $RotatingSprite/Area2D

func _ready() -> void:
	on_exited_range()

func on_entered_range() -> void:
	rotating_sprite.modulate = Color.WHITE
	
func on_exited_range() -> void:
	rotating_sprite.modulate = Color.WHITE * 0.7

func disable_area_2d() -> void:
	area_2d.visible = false
