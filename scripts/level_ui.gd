extends Control

static var AirBarNormal := preload("res://ui/AirBarNormal.tres")
static var AirBarLow := preload("res://ui/AirBarLow.tres")

@onready var manager = LevelManager.instance(self)
@onready var air_bar = $AirBar/Bar
var air_bar_low = false

func _process(_delta: float) -> void:
	var player = manager.player;
	if not player or player.is_dead:
		return
	_update_air_bar(player.air / player.MaxAir)

func _update_air_bar(frac: float) -> void:
	air_bar.value = frac
	if frac < 0.2:
		if not air_bar_low:
			air_bar.add_theme_stylebox_override("fill", AirBarLow)
			air_bar_low = true
	else:
		if air_bar_low:
			air_bar.add_theme_stylebox_override("fill", AirBarNormal)
			air_bar_low = false
