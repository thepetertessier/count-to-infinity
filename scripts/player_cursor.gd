@tool
class_name PlayerCursor
extends CharacterBody2D

signal collided_with_trap(collision: KinematicCollision2D)

@onready var hit_collision_shape: CollisionShape2D = $HitBox/HitCollisionShape
@onready var cpu_particles_2d: CPUParticles2D = $Visuals/CPUParticles2D
@onready var halo_parent: Node2D = $Visuals/HaloParent
@onready var hit_box: Area2D = $HitBox

@export var click_radius: float = 1.0:
	set(value):
		click_radius = value
		const default_radius := 20.0  # when click_radius is one
		var collision_radius = default_radius * click_radius
		hit_collision_shape.shape.set_radius(collision_radius)
		cpu_particles_2d.set_emission_sphere_radius(collision_radius)
		cpu_particles_2d.set_amount(500 * sqrt(click_radius))
		halo_parent.set_scale(click_radius * Vector2.ONE)

func _ready():
	#Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	pass

func _physics_process(delta):
	if Engine.is_editor_hint():
		return
	var to_go = get_global_mouse_position() - global_position
	var collision = move_and_collide(to_go)

func get_hit_box() -> Area2D:
	return hit_box
