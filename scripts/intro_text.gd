extends RichTextLabel
signal text_finished

var story_text = "Test text"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scroll_text(story_text)

func scroll_text(input_text: String) -> void:
	visible_characters = 0
	text = input_text

	for i in input_text.length():
		visible_characters += 1
		await get_tree().create_timer(0.04).timeout

	emit_signal("text_finished")
	
