extends Node2D

signal clicked

func _on_area_2d_clicked() -> void:
	clicked.emit()
