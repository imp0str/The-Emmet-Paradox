extends Node2D

@onready var intro_timer: Timer = $IntroTimer
@onready var door: StaticBody2D = $TestChamberDoor

func _ready():
	intro_timer.start()
	NarratorManager.dialog_done.connect(_on_narrator_dialog_done)

func _on_intro_timer_timeout() -> void:
	print("Intro Started")
	NarratorManager.say_lines("intro")

func _on_narrator_dialog_done() -> void:
	print("Narrator finished intro! Opening door...")
	NarratorManager.dialog_done.disconnect(_on_narrator_dialog_done)
	var tw = create_tween()
	tw.tween_property(door, "position:y", door.position.y - 98, 2.0).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)


func _on_area_2d_body_entered(body: Node2D) -> void:
	SceneManager.GameController.change_2d_scene_with_transition("res://Scenes/Levels/chamber_1.tscn")
