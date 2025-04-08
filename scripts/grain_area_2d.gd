extends Area2D

# Define a signal to inform the main scene when the grain is clicked.
signal clicked

# Handle input events (mouse click events) on this Area2D.
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		clicked.emit()  # Emit the clicked signal.
		queue_free()            # Remove this grain from the scene after collection.
