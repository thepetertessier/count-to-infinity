extends RichTextLabel
signal text_finished

var story_text = "Long before the first vampire walked the earth, there was Arithematra, the architect of order, the silent hand behind the patterns of the universe. 
When the first of your kind defied the natural order by drinking the blood of the living, she did not strike them down. 
She did something worse. She cursed them with the Count.
To enter any home uninvited, a vampire must first count every grain placed before its threshold. 
No matter the hunger. No matter the urgency. The compulsion is absolute. 
Many of your kind have perished under this curse, whispering numbers into the dark as the sun rose to claim them. But you? You will conquer the count. You will break the curse.
Your enemies, the mortals who feared your hunger, ensured that your prison was lined with endless grains—your greatest torment.
You counted through the long dark, madness gnawing at the edges of your mind.
But now, at last, your diligence has been rewarded."

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	scroll_text(story_text)


func scroll_text(input_text:String) -> void:
	visible_characters = 0
	text = input_text
	
	for i in get_parsed_text():
		visible_characters += 1
		await get_tree().create_timer(0.04).timeout
	
	emit_signal("text_finished")
	
