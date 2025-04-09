extends Node

const pop_sound_count := 5

var pop_audio_players = []
var collect_audio_players = []

@onready var hover_player: AudioStreamPlayer = $HoverPlayer
@onready var stage_complete_player: AudioStreamPlayer = $StageCompletePlayer

func make_new_player(stream: AudioStream) -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.max_polyphony = 4
	player.set_stream(stream)
	player.set_bus("SFX")
	add_child(player)
	return player

# Create a pool of, say, 8 players (adjust number as needed)
func _ready():
	for i in range(1, pop_sound_count+1):
		var sound: AudioStreamOggVorbis = load("res://assets/sfx/pop" + str(i) + ".ogg")
		var player = make_new_player(sound)
		pop_audio_players.append(player)
		
		var player2 = make_new_player(sound)
		collect_audio_players.append(player2)

func play_pop():
	pop_audio_players[randi_range(0, pop_sound_count-1)].play()

func play_hover():
	hover_player.play()

func play_collect():
	collect_audio_players[randi_range(0, pop_sound_count-1)].play()
	
func play_stage_complete():
	stage_complete_player.play()
