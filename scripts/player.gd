extends CharacterBody2D

const MaxVelocity = 200.0
const Acceleration = 300.0
const Friction = 0.3
const FrictionThreshold = 30.0
const FRICTION_DELTA = 100.0

@onready var sprite: Node2D = $Sprites
@onready var animation: AnimatedSprite2D = $Sprites/AnimatedDolphin
var is_dead = false
var enemies_group = "Enemies"

func _ready():
	get_tree().current_scene.get_node("GameManager").player = self

func _physics_process(delta):
	if is_dead:
		animation.pause()
		animation.frame = 0
		if position.y < 0:
			velocity = Vector2.ZERO
			return
		sprite.scale.y = -1
		velocity.x = 0
		move_to(Vector2(0, -1), delta)
		move_and_slide()
		return
	
	move_to(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"), delta)
	move_and_slide()
	clamp_position()

	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Node:
			on_collision(collider)


func move_to(input: Vector2, delta: float):
	if input != Vector2.ZERO:
		velocity += input.normalized() * Acceleration * delta
		velocity = velocity.limit_length(MaxVelocity)
	elif velocity.length() > FrictionThreshold:
		velocity *= pow(Friction, delta)
	else:
		velocity = velocity.limit_length(max(0, velocity.length() - FRICTION_DELTA * delta))

	if velocity.x > 0:
		sprite.scale.x = 1
	elif velocity.x < 0:
		sprite.scale.x = -1

	if velocity.length() > 0:
		animation.play()
	elif animation.frame == 0:
		animation.pause()

func clamp_position():
	position.x = max(0, position.x)
	position.y = max(0, position.y)
	velocity.x = max(0, velocity.x) if position.x == 0 else velocity.x
	velocity.y = max(0, velocity.y) if position.y == 0 else velocity.y

func on_collision(node: Node):
	if node.is_in_group(enemies_group):
		die()

func die():
	is_dead = true
	$CollisionShape2D.disabled = true
