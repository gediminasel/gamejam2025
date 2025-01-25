extends Node
class_name GameManager

const TileSize = 32

@export var cornerMarker: Node2D;

func level_size_in_pixels() -> Vector2:
	return cornerMarker.position

# only available after _ready!
var player: Player = null;
