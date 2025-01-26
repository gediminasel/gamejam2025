extends Camera2D

@onready var manager = LevelManager.instance(self)
@onready var minPos = get_viewport_rect().size / 2
@onready var maxPos = manager.level_size_in_pixels() - get_viewport_rect().size / 2

func _ready() -> void:
	update_position()

func _physics_process(_delta: float) -> void:
	update_position()
	
func update_position():
	var player = manager.player
	if player:
		position = player.position.clamp(minPos, maxPos)
