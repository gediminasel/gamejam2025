extends CPUParticles2D
class_name SplashParticles

func _ready() -> void:
	emitting = true
	one_shot = true

func _on_timer_timeout() -> void:
	queue_free()
