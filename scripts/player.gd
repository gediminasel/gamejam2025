extends CharacterBody2D
class_name Player

const MaxVelocity = 200.0
const Acceleration = 300.0
const Friction = 0.3
const FrictionThreshold = 30.0
const FRICTION_DELTA = 100.0
const FRICTION_GROUND_DELTA = 200.0

const MaxAir = 10
const AirToShoot = 1
const AirUsageSpeed = 0.2
const AirBreathSpeed = 2

const EnemiesGroup = "Enemies"

static var SplashScene := preload("res://entities/SplashParticles.tscn")
static var BubbleScene := preload("res://entities/BubbleRing.tscn")
const BubbleShootOffset = Vector2(15, 0)  # offset to mouth
const BubbleAdditionalSpeed = 50

@onready var manager = LevelManager.instance(self)

@onready var sprite: Node2D = $Sprites
@onready var animation: AnimatedSprite2D = $Sprites/AnimatedDolphin
@onready var in_air = $InAir as InAir
var is_dead = false
var is_win = false

var air = 10
var on_ground = false
	
func _input(event):
	if is_dead:
		return
	if event.is_action_pressed("shoot"):
		shoot()

func _physics_process(delta):
	if is_dead:
		_process_dead_animation(delta)
		return
	
	var input = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if is_win:
		input = Vector2.ZERO
	if in_air.in_air:
		if on_ground:
			input = Vector2(0, 0)
		else:
			input = Vector2(0, 1)
	move_to(input, delta)
	move_and_slide()
	velocity = get_real_velocity()
	
	clamp_position()
	
	on_ground = false
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider is Node:
			if collider.is_in_group(EnemiesGroup):
				die()
				return
			if collider.is_in_group("Ground"):
				if in_air.in_air:
					on_ground = true

	if air <= 0 and manager:
		die()
		return
	if in_air.in_air:
		air = min(air + delta * AirBreathSpeed, MaxAir)
	else:
		air = max(0, air - delta * AirUsageSpeed)


func _process_dead_animation(delta: float) -> void:
	animation.pause()
	animation.frame = 0
	if position.y < -50:
		velocity = Vector2.ZERO
		queue_free()
		return
	sprite.scale.y = -1
	velocity.x = 0
	velocity += Vector2(0, -1) * Acceleration * delta
	velocity = velocity.limit_length(MaxVelocity)
	move_and_slide()

func move_to(direction: Vector2, delta: float):
	if direction != Vector2.ZERO:
		velocity += direction.normalized() * Acceleration * delta
		velocity = velocity.limit_length(MaxVelocity)
	elif on_ground:
		velocity = velocity.limit_length(max(0, velocity.length() - FRICTION_GROUND_DELTA * delta))
	elif velocity.length() > FrictionThreshold:
		velocity *= pow(Friction, delta)
	else:
		velocity = velocity.limit_length(max(0, velocity.length() - FRICTION_DELTA * delta))

	if direction.x > 0 and velocity.x > 0.1:
		sprite.scale.x = 1
	elif direction.x < 0 and velocity.x < 0.1:
		sprite.scale.x = -1

	if velocity.length() > 0:
		animation.play()
	elif animation.frame == 0:
		animation.pause()

func clamp_position():
	var max_pos = manager.level_size_in_pixels() if manager != null else Vector2(1000, 1000)
	position = position.clamp(Vector2.ZERO, max_pos)
	velocity.x = max(0, velocity.x) if position.x == 0 else velocity.x
	velocity.y = max(0, velocity.y) if position.y == 0 else velocity.y
	velocity.x = min(0, velocity.x) if position.x == max_pos.x else velocity.x
	velocity.y = min(0, velocity.y) if position.y == max_pos.y else velocity.y

func die():
	if is_dead or is_win:
		return
	is_dead = true
	$CollisionShape2D.disabled = true
	manager.on_finish(false)

func win():
	if is_dead or is_win:
		return
	is_win = true

func shoot():
	if air < 2 * AirToShoot:
		return
	if in_air.in_air:
		return
	air -= AirToShoot
	var new_bubble = BubbleScene.instantiate() as Bubble
	var direction = velocity
	if direction == Vector2.ZERO:
		direction = Vector2(1, 0) if sprite.scale.x > 0 else Vector2(-1, 0)
	new_bubble.velocity = direction.normalized() * (velocity.length() + BubbleAdditionalSpeed)
	var bubble_position = position
	if sprite.scale.x > 0:
		bubble_position += BubbleShootOffset
	else:
		bubble_position -= BubbleShootOffset
	new_bubble.position = bubble_position
	get_tree().current_scene.add_child(new_bubble)

func on_air_enter():
	const min_vel = 40
	if velocity.length() < min_vel:
		if velocity == Vector2.ZERO:
			velocity = Vector2(0, -min_vel)
		else:
			velocity *= min_vel / velocity.length()
	else:
		var splash = SplashScene.instantiate() as SplashParticles
		splash.position = position
		splash.initial_velocity_min = velocity.length()
		splash.initial_velocity_max = splash.initial_velocity_min + 50
		get_tree().current_scene.add_child(splash)

func on_air_exit():
	velocity = velocity.limit_length(0.5 * velocity.length())
	
func air_bubble_collected():
	air = min(air + AirToShoot, MaxAir)
