extends CharacterBody2D

const Speed = 150

var dead = false
var dead_move_up = false
var dead_move_timer = 5

func _physics_process(delta: float) -> void:
	if dead_move_up:
		position.y -= delta * Speed
		dead_move_timer -= delta
		if dead_move_timer < 0:
			queue_free()
	
func die():
	dead = true
	$CollisionShape2D.set_deferred("disabled", true)
	$Sprites/Normal.visible = false
	$Sprites/Dead.visible = true
	$Sprites/Dead.play()
	
func _on_dead_animation_finished() -> void:
	dead_move_up = true
