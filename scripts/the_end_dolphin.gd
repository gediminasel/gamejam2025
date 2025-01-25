extends Node2D

const MaxVelocity = 200.0
const Acceleration = 300.0

var velocity = Vector2(0, 0)
var direction = Vector2(1, 1)

func _physics_process(delta):
	move_to(get_input(), delta)
	position += velocity * delta

func move_to(input: Vector2, delta: float):
	velocity += input.normalized() * Acceleration * delta
	velocity = velocity.limit_length(MaxVelocity)

	if velocity.x > 0:
		scale.x = 1
	elif velocity.x < 0:
		scale.x = -1

func get_input():
	if position.x < 100:
		direction.x = 1
	elif position.x > 500:
		direction.x = -1
	if position.y > 150:
		direction.y = -1
	elif position.y < 100:
		direction.y = 1
	if position.y < 100:
		return Vector2(0, 1)
	return direction
