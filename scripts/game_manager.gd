extends Node
class_name GameManager

const TileSize = 32

var levelSize = Vector2(20, 24)

func level_size_in_pixels() -> Vector2:
	return TileSize * levelSize

# only available after _ready!
var player: Node2D = null;
