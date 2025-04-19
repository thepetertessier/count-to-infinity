extends RigidBody2D

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _physics_process(delta):
	var to_go = get_global_mouse_position() - global_position
	#velocity = to_go / delta
	#move_and_slide()
	move_and_collide(to_go)
