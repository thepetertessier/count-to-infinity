extends Node


@onready var text_label = $Intro_Text
@onready var seed = $SunflowerSeed
@onready var tutorial = $TutorialNode
@onready var animation_player = $AnimationPlayer2

func _ready() -> void:
	text_label.connect("text_finished", Callable(self, "_on_text_finished"))
	seed.visible = false  # make sure seed is hidden initially
	Input.set_custom_mouse_cursor(VAMPIRE_HAND, 0, Vector2(13,0))
	seed.clicked.connect(_on_seed_clicked)

func _on_text_finished():
	await get_tree().create_timer(3.0).timeout  # wait for 3 seconds
	await fade_out_text()
	seed.visible = true
	seed.get_node("AnimationPlayer2").play("Tutorial")  
	seed.get_node("AnimationPlayer").play("teeter")
	
func fade_out_text() -> void:
	# Optional fade out using a tween
	var tween = get_tree().create_tween()
	tween.tween_property(text_label, "modulate:a", 0.0, 1.5)
	await tween.finished
	
func _input(event):
	if event.is_action_pressed("ui_accept"): 
		SceneSwitcher.goto_scene_from_path("res://scenes/resting_menu.tscn")
		
func _on_seed_clicked():
	var tween = create_tween()
	tween.tween_property(seed, "scale", Vector2(), 0.5)
	tween.tween_callback(seed.queue_free)

	await tween.finished 
	var counting_text = $Counting_Text
	counting_text.visible = true
	counting_text.scroll_text("\"3,485,453,233...\"")

	await counting_text.text_finished
	await get_tree().create_timer(1.5).timeout

	var fade_tween = create_tween()
	fade_tween.tween_property(counting_text, "modulate:a", 0.0, 1.5)
	await fade_tween.finished

	counting_text.visible = false
		

const VAMPIRE_HAND = preload("res://assets/images/vampire_hand.png")

		
