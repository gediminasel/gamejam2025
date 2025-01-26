extends Node2D


func _on_finish_body_exited(body: Node2D) -> void:
	if body.is_in_group("Player"):
		LevelManager.instance(self).on_finish(true)
