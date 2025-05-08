extends StaticBody2D

@onready var sprite := $Sprite2D
@onready var area := $Area2D

var original_position: Vector2
var falling := false
var shake_timer := 0.0
var shake_duration := 0.5

func _ready():
	original_position = global_position
	area.body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player" and not falling:
		shake_timer = shake_duration
		set_process(true)  # start shaking

func _process(delta: float) -> void:
	if shake_timer > 0:
		shake_timer -= delta
		# Shake left/right randomly
		var shake_offset = Vector2(randf_range(-2, 2), 0)
		global_position = original_position + shake_offset

		if shake_timer <= 0:
			set_process(false)
			start_falling()

func start_falling():
	falling = true
	set_physics_process(true)
	original_position = global_position  # reset shake position
	# Start a timer to queue_free after 8 seconds
	await get_tree().create_timer(8.0).timeout
	queue_free()

func _physics_process(delta: float) -> void:
	if falling:
		global_position.y += 300 * delta  # fall speed
