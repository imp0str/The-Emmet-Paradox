extends Node

@onready var music_player = $BGMusic

func play_music():
	if not music_player.playing:
		music_player.play()

func stop_music():
	if music_player.playing:
		music_player.stop()
