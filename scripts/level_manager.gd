extends Node
class_name LevelManager

const TileSize = 32

@onready var player: Player = get_parent().get_node("Player")
@onready var cornerMarker: Marker2D = get_parent().get_node("CornerMarker")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("restart"):
		GameManager.instance(self).retry()

static func instance(obj: Node) -> LevelManager:
	return obj.get_tree().current_scene.get_node("LevelManager") as LevelManager

func level_size_in_pixels() -> Vector2:
	return cornerMarker.position

func on_finish(success: bool):
	player = null
	var gm = GameManager.instance(self)
	if success:
		gm.next_level()
	else:
		gm.retry()
