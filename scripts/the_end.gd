extends Control

func _input(event: InputEvent) -> void:
	if event.is_action("ui_accept"):
		back()
		
func _on_back_button_pressed() -> void:
	back()
	
func back() -> void:
	GameManager.instance(self).start_menu()
