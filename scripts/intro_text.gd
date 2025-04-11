extends RichTextLabel
signal text_finished

var story_text = "Long before the first vampire walked the earth, there was Arithematra—the Matron of the Countless. A cosmic force of pure calculation. Architect of order. The silent hand behind the patterns of the universe.

When the first of your kind defied nature by drinking the blood of the living, she did not strike them down. She did something worse.

She cursed them with the Count.

To enter any home uninvited, a vampire must first count every grain placed at its threshold. No matter the hunger. No matter the danger. The compulsion is absolute.

Many have perished under this curse, whispering numbers into the dark as dawn consumed them.

But not you.

You are Velka, the Hungering Sovereign. The last of the old lords. Sealed in a crypt for centuries. Your prison lined with grains—endless, infinite grains—your torment made manifest.

But now…"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scroll_text(story_text)

func scroll_text(input_text: String) -> void:
	visible_characters = 0
	text = input_text

	for i in input_text.length():
		visible_characters += 1
		await get_tree().create_timer(0.05).timeout

	emit_signal("text_finished")
	
