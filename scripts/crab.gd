extends CharacterBody2D

const Speed = 100.0
const Distance = 100.0

@onready var normal_sprite: Sprite2D = $Sprites/Normal
@onready var angry_sprite: Sprite2D = $Sprites/Angry

@onready var manager = LevelManager.instance(self)
var dead = false
var dead_timer = 3

func _physics_process(delta):
	if dead:
		velocity += get_gravity() * delta

		dead_timer -= delta
		if dead_timer < 0:
			queue_free()
		else:
			move_and_slide()
		return

	velocity += get_gravity() * delta
	
	var player = manager.player
	var direction = player.position - position if player and not player.is_dead else Vector2(1000000, 1000000)
	var is_close = direction.length() < Distance

	if is_close:
		angry_sprite.visible = true
		normal_sprite.visible = false
	else:
		angry_sprite.visible = false
		normal_sprite.visible = true

	if is_close and abs(direction.x) > 10:
		velocity.x = Speed if direction.x > 0 else -Speed
	elif not is_close:
		velocity.x = lerp(velocity.x, 0.0, Speed * delta)

	move_and_slide()

func die():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	velocity = Vector2(0, -200)
