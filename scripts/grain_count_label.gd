extends Label

var finished := false

func set_new_text(new_text):
	if finished:
		return
	text = new_text

func big_center_text(new_text):
	if finished:
		return
	finished = true
	text = new_text
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", Vector2(330, 425), 1)
	tween.parallel().tween_property(self, "scale", Vector2(1,1)*2, 1)
