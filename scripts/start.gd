extends Control

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		start_game()

func _on_button_pressed() -> void:
	start_game()

func start_game() -> void:
	GameManager.instance(self).start_game()
