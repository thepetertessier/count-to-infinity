extends RichTextLabel
signal text_finished

var story_text = "Long before the first vampire walked the earth, there was Arithematra—the Matron of the Countless. She was the architect of order. The silent hand behind the patterns of the universe.

When the first of your kind defied nature by drinking the blood of the living, she did not strike them down. She did something worse.

She cursed them with the Count.

To enter any home uninvited, a vampire must first count every grain placed at its threshold. No matter the hunger. No matter the danger. The compulsion is absolute.

Many have perished under this curse, whispering numbers into the dark as dawn consumed them.

But not you.

You are Velka, the Hungering Sovereign, the last of the old lords, sealed in a crypt for centuries. Your prison lined with endless grains, you count them one by one.

Until…"

var story_lines = []
var current_line = 0
var skipping = false
var scrolling = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	story_lines = story_text.split("\n\n")  # splits by paragraph
	show_next_line()


func show_next_line() -> void:
	if current_line >= story_lines.size():
		emit_signal("text_finished")
		return
	scroll_text(story_lines[current_line])
	
	
func scroll_text(input_text: String) -> void:
	var old_text = text
	var prefix = ""
	if old_text.length() > 0:
		prefix = "\n\n"
	var new_text = old_text + prefix + input_text

	text = new_text
	visible_characters = old_text.length()
	scrolling = true
	skipping = false

	for i in input_text.length():
		if skipping:
			break
		visible_characters += 1
		await get_tree().create_timer(0.03).timeout

	visible_characters = new_text.length()
	scrolling = false

func _on_next_line_pressed() -> void:
	if scrolling:
		skipping = true
	else:
		current_line += 1
		show_next_line()
		
