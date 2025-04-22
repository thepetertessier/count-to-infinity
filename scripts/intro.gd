extends Node


@onready var text_label = $Intro_Text
@onready var animation_player = $AnimationPlayer2

const VAMPIRE_HAND = preload("res://assets/images/vampire_hand.png")

# arrays of seeds and matching texts
@onready var seeds = [
	$SunflowerSeed1,
	$SunflowerSeed2,
	$SunflowerSeed3
]

@onready var counting_texts = [
	$Counting_Text1,
	$Counting_Text2,
	$Counting_Text3
]

# dialog text for each step
var counting_lines = [
	"\"3,485,453,233...\"",
	"\"3,485,453,234...\"",
	"\"3,485,453,235...\""
]


func _ready() -> void:
	text_label.connect("text_finished", Callable(self, "_on_text_finished"))
	Input.set_custom_mouse_cursor(VAMPIRE_HAND, 0, Vector2(13,0))
	
	# make all seeds hidden initially
	for seed in seeds:
		seed.visible = false

func _on_text_finished():
	await get_tree().create_timer(3.0).timeout  # wait for 3 seconds
	await fade_out_text()
	for i in seeds.size():
		var seed = seeds[i]
		var counting_text = counting_texts[i]
		var line = counting_lines[i]

		await show_seed_and_wait_for_click(seed)
		await show_counting_text(counting_text, line)

	# Final sequence after the 3rd one
	await get_tree().create_timer(2.0).timeout
	await show_vampire_freedom()
	
func fade_out_text() -> void:
	var tween = get_tree().create_tween()
	tween.tween_property(text_label, "modulate:a", 0.0, 1.5)
	await tween.finished
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		SceneSwitcher.goto_scene_from_path("res://scenes/resting_menu.tscn")

func show_seed_and_wait_for_click(seed: Node) -> void:
	seed.visible = true
	seed.get_node("AnimationPlayer2").play("Tutorial")
	seed.get_node("AnimationPlayer").play("teeter")

	var tween = null

	# Connect ONCE and disconnect right after
	var conn = await seed.clicked

	tween = create_tween()
	tween.tween_property(seed, "scale", Vector2(), 0.5)
	tween.tween_callback(seed.queue_free)
	await tween.finished

func show_counting_text(label: RichTextLabel, text: String) -> void:
	label.visible = true
	label.scroll_text(text)
	await label.text_finished
	await get_tree().create_timer(1.5).timeout

	var fade_tween = create_tween()
	fade_tween.tween_property(label, "modulate:a", 0.0, 1.5)
	await fade_tween.finished
	label.visible = false
	
func fade_out_music(audio_player: AudioStreamPlayer, duration: float = 2.0) -> void:
	var tween = create_tween()
	tween.tween_property(audio_player, "volume_db", -80, duration)
	await tween.finished
	audio_player.stop()

func show_vampire_freedom():
	var final_text = $FinalDialog
	final_text.visible = true

	# Show initial dramatic realization
	await show_counting_text(final_text, "\"Wait... I did it... I finally did it!\"\n\n\"I've counted them all!\"\n\n\"This wretched prison can no longer contain me!\"")
	
	# Sinister red fade after realization
	var red_overlay = $RedOverlay
	red_overlay.visible = true
	red_overlay.modulate.a = 0.0

	var fade_tween = create_tween()
	fade_tween.tween_property(red_overlay, "modulate:a", 1.0, 2.0)
	await fade_tween.finished

	# follow-up line, now under red light
	var final_text2 = $FinalDialog2
	final_text2.visible = true
	await show_counting_text(final_text2, "\"After all this time, I've grown so hungry.\"\n\n\"I don't care how much more grain I have to count! I WILL feast tonight!\"")
	
	var final_text3 = $FinalDialog3
	final_text3.visible = true
	await show_counting_text(final_text3, "[b]\"THE WORLD WILL KNOW TRUE FEAR ONCE AGAIN!\"[/b]")
	
	var black_overlay = $BlackOverlay
	black_overlay.visible = true
	black_overlay.modulate.a = 0.0
	var new_fade_tween = create_tween()
	new_fade_tween.tween_property(black_overlay, "modulate:a", 1.0, 2.0)
	await new_fade_tween.finished
	
	await fade_out_music($Music)
	
	await get_tree().create_timer(1.0).timeout
	SceneSwitcher.goto_scene_from_path("res://scenes/resting_menu.tscn")
	
	
		


		
