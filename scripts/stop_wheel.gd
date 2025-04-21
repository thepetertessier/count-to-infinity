extends TextureButton

func _on_pressed() -> void:
	self.hide()

func _process(delta: float) -> void:
	var cen = Vector2(get_viewport_rect().size / 2)
	self.position = cen - self.get_size()/2
