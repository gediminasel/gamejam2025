extends Camera2D

@onready var game_manager = get_tree().current_scene.get_node("GameManager") as GameManager
@onready var minPos = get_viewport_rect().size / 2
@onready var maxPos = game_manager.level_size_in_pixels() - get_viewport_rect().size / 2

func _physics_process(_delta: float) -> void:
	position = game_manager.player.position.clamp(minPos, maxPos)
