extends Node2D

signal clicked

func _on_area_2d_clicked() -> void:
	print("clicked!")
	clicked.emit()
	queue_free()
