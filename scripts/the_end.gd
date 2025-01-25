extends Control

func _on_back_button_pressed() -> void:
	GameManager.instance(self).start_menu()
