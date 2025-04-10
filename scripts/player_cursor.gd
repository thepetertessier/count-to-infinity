extends CharacterBody2D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _physics_process(delta):
	move_and_collide(get_global_mouse_position() - global_position)
