extends RichTextLabel
signal text_finished

func scroll_text(input_text: String) -> void:
	visible_characters = 0
	text = input_text

	for i in input_text.length():
		visible_characters += 1
		await get_tree().create_timer(0.03).timeout

	emit_signal("text_finished")
