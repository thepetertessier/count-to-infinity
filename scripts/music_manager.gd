extends Node

@onready var ambient_player: AudioStreamPlayer = $AmbientPlayer

func fade_out(seconds: float):
	var tween = get_tree().create_tween()
	tween.tween_property(ambient_player, "volume_db", -20, seconds)
	tween.tween_callback(ambient_player.stop)
