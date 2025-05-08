extends Node2D



func _on_button_pressed() -> void:
	SceneManager.GameController.change_2d_scene_with_transition("res://Scenes/Levels/test_chamber.tscn")
	MusicManager.play_music()
