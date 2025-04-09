extends Label

func big_center_text(new_text):
	text = new_text
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(330, 425), 1)
	tween.parallel().tween_property(self, "scale", Vector2(1,1)*2, 1)
