@tool
class_name PlayerCursor
extends RigidBody2D

@onready var hit_collision_shape: CollisionShape2D = $HitBox/HitCollisionShape
@onready var cpu_particles_2d: CPUParticles2D = $Visuals/CPUParticles2D

@export var click_radius: float = 1.0:
	set(value):
		click_radius = value
		const default_radius := 20.0  # when click_radius is one
		var collision_radius = default_radius * click_radius
		hit_collision_shape.shape.set_radius(collision_radius)
		cpu_particles_2d.set_emission_sphere_radius(collision_radius)
		cpu_particles_2d.set_amount(500 * sqrt(click_radius))

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	var to_go = get_global_mouse_position() - global_position
	#velocity = to_go / delta
	#move_and_slide()
	move_and_collide(to_go)
