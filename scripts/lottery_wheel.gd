extends Node2D

# Exported array to list out the wheel’s segments (prizes or values).
# You can modify these values in the editor easily.
@export var segment_values: Array = ["Prize 1", "Prize 2", "Prize 3", "Prize 4", "Prize 5"]

# Rotation speed in radians per second.
@export var rotation_speed: float = 5.0

@onready var sprinning_wheel: Sprite2D = $SprinningWheel

# Flag to indicate that deceleration is in progress.
var decelerating = false
var stopped = false

func _process(delta):
	# Only rotate normally if we aren’t decelerating.
	if not stopped:
		sprinning_wheel.rotation += rotation_speed * delta

# This function uses a Tween to slow the rotation to a stop.
func decelerate_rotation():
	decelerating = true
	# Create a Tween node to interpolate the rotation_speed property.
	var tween = get_tree().create_tween()
	tween.set_trans(Tween.TRANS_QUAD)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "rotation_speed", 0, 3.0)
	tween.tween_callback(_on_deceleration_complete)

# Optional: Called when the tween finishes.
func _on_deceleration_complete(object, key):
	# When the tween is finished, the wheel has stopped spinning.
	# You can trigger an event to handle the final result,
	# such as checking which segment the pointer is pointing at.
	stopped = true
	print("Wheel has stopped!")

func _on_stop_button_pressed() -> void:
	# Prevent multiple button presses triggering multiple deceleration sequences.
	if not decelerating:
		decelerate_rotation()
