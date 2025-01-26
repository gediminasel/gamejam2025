extends Node
class_name LevelManager

const TileSize = 32

@onready var player: Player = get_parent().get_node("Player")
@onready var cornerMarker: Marker2D = get_parent().get_node("CornerMarker")

var success = false

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameManager.instance(self).retry()
	if event.is_action_pressed("cheat_next_level"):
		GameManager.instance(self).next_level()
	if event.is_action_pressed("prev_level"):
		GameManager.instance(self).prev_level()

static func instance(obj: Node) -> LevelManager:
	return obj.get_tree().current_scene.get_node("LevelManager") as LevelManager

func level_size_in_pixels() -> Vector2:
	return cornerMarker.position

func on_finish(is_success: bool):
	if is_success and player:
		player.win()
	player = null
	success = is_success
	$FinishTimer.start()

func _on_finish_timer_timeout() -> void:
	var gm = GameManager.instance(self)
	if success:
		gm.next_level()
	else:
		gm.retry()
