extends TextureButton

func _on_pressed() -> void:
	self.hide()
	
	# play wheel spin outro
	var endless_wheel_spin = get_node("../EndlessWheelSpinSoundEffect")
	endless_wheel_spin.stop()
	
	var ending_spinner = get_node("../EndingSpin")
	ending_spinner.play()
