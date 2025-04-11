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
		get_tree().change_scene_to_file("res://scenes/resting_menu.tscn")
		
func _on_seed_clicked():
	var tween = create_tween()
	tween.tween_property(seed, "scale", Vector2(), 0.5)
	tween.tween_callback(seed.queue_free)
		

const VAMPIRE_HAND = preload("res://assets/images/vampire_hand.png")

		
