extends CharacterBody2D

const MaxVelocity = 200.0
const Acceleration = 300.0
const Friction = 0.3
const FrictionThreshold = 30.0
const FRICTION_DELTA = 100.0

const EnemiesGroup = "Enemies"

static var BubbleScene := preload("res://entities/Bubble.tscn")
const BubbleShootOffset = Vector2(15, 0)  # offset to mouth
const BubbleAdditionalSpeed = 50

@onready var game_manager = get_tree().current_scene.get_node("GameManager") as GameManager

@onready var sprite: Node2D = $Sprites
@onready var animation: AnimatedSprite2D = $Sprites/AnimatedDolphin
var is_dead = false
var last_non_zero_velocity = Vector2(1, 0)

func _ready():
	game_manager.player = self
	
func _input(event):
	if event.is_action_pressed("shoot"):
		shoot()

func _physics_process(delta):
	if is_dead:
		animation.pause()
		animation.frame = 0
		if position.y < -50:
			velocity = Vector2.ZERO
			return
		sprite.scale.y = -1
		velocity.x = 0
		move_to(Vector2(0, -1), delta)
		move_and_slide()
		return
	
	move_to(Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down"), delta)
	move_and_slide()
	
	if velocity != Vector2.ZERO:
		last_non_zero_velocity = velocity
	
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
	var max_pos = game_manager.level_size_in_pixels()
	position = position.clamp(Vector2.ZERO, max_pos)
	velocity.x = max(0, velocity.x) if position.x == 0 else velocity.x
	velocity.y = max(0, velocity.y) if position.y == 0 else velocity.y
	velocity.x = min(0, velocity.x) if position.x == max_pos.x else velocity.x
	velocity.y = min(0, velocity.y) if position.y == max_pos.y else velocity.y

func on_collision(node: Node):
	if node.is_in_group(EnemiesGroup):
		die()

func die():
	is_dead = true
	$CollisionShape2D.disabled = true

func shoot():
	var new_bubble = BubbleScene.instantiate() as Bubble
	new_bubble.velocity = last_non_zero_velocity.normalized() * (velocity.length() + BubbleAdditionalSpeed)
	var bubble_position = position
	if sprite.scale.x > 0:
		bubble_position += BubbleShootOffset
	else:
		bubble_position -= BubbleShootOffset
	new_bubble.position = bubble_position
	get_tree().current_scene.add_child(new_bubble)
