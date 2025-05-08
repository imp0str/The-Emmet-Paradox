class_name GameController
extends Node

@export var world_2d: Node2D
@export var color_rect: ColorRect
@export var narrator_text: RichTextLabel

var current_2d_scene

func _ready() -> void:
	SceneManager.GameController = self
	current_2d_scene = $World2D/MainMenu

	# Connect narrator manager signals
	NarratorManager.speak_line.connect(_on_narrator_speak_line)
	NarratorManager.dialog_done.connect(_on_narrator_dialog_done)

func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if current_2d_scene != null:
		if delete:
			current_2d_scene.queue_free()
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.remove_child(current_2d_scene)
	var new_scene_instance = load(new_scene).instantiate()
	world_2d.add_child(new_scene_instance)
	current_2d_scene = new_scene_instance

func change_2d_scene_with_transition(new_scene: String, delete: bool = true, keep_running: bool = false):
	if color_rect == null:
		push_error("TransitionOverlay not assigned!")
		change_2d_scene(new_scene, delete, keep_running)
		return

	var tw = create_tween()
	tw.tween_property(color_rect, "modulate:a", 1.0, 1.5)
	tw.tween_callback(func():
		_do_change_2d_scene(new_scene, delete, keep_running)
		var tw2 = create_tween()
		tw2.tween_property(color_rect, "modulate:a", 0.0, 1.5)
	)

func _do_change_2d_scene(new_scene: String, delete: bool, keep_running: bool):
	change_2d_scene(new_scene, delete, keep_running)

func _on_narrator_speak_line(text: String) -> void:
	narrator_text.text = text
	narrator_text.visible_characters = 0
	_type_text(text)

func _type_text(text: String) -> void:
	for i in range(text.length()):
		narrator_text.visible_characters = i + 1
		await get_tree().create_timer(0.09).timeout
	await get_tree().create_timer(2.0).timeout

	if NarratorManager.dialog_queue.is_empty():
		# LAST LINE → fade + trigger dialog_done AFTER fade
		var tw = create_tween()
		tw.tween_property(narrator_text, "modulate:a", 0.0, 2.0)
		await tw.finished
		NarratorManager.finished_line()  # will emit dialog_done
	else:
		NarratorManager.finished_line()

func _on_narrator_dialog_done() -> void:
	print("Narrator finished all lines! (GameController)")
