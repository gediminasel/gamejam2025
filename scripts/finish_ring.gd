extends Node2D


func _on_finish_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		LevelManager.instance(self).on_finish(true)
		$WinParticles.visible = true
		$WinParticles.emitting = true
		$WinParticles.one_shot = true
