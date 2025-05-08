extends CharacterBody2D

const SPEED = 250.0
const ACCELERATION = 1200.0
const AIR_ACCELERATION = 600.0
const FRICTION = 800.0
const JUMP_VELOCITY = -475.0
const MAX_JUMPS = 2

var jump_count = 0

func _physics_process(delta: float) -> void:
	# Gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jump_count = 0  # Reset jump count on landing

	# Handle jump
	if Input.is_action_just_pressed("jump") and jump_count < MAX_JUMPS:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Movement input
	var direction := Input.get_axis("left", "right")

	var target_speed = direction * SPEED
	var acceleration = ACCELERATION if is_on_floor() else AIR_ACCELERATION


	# Smooth acceleration and deceleration
	if direction != 0:
		# If changing direction mid-air, reduce air control
		if not is_on_floor() and sign(direction) != sign(velocity.x):
			velocity.x = move_toward(velocity.x, target_speed, acceleration * 0.5 * delta)
		else:
			velocity.x = move_toward(velocity.x, target_speed, acceleration * delta)
	else:
		# Decelerate when no input
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

	move_and_slide()
