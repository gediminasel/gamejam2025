extends Node
class_name InAir

signal air_enter
signal air_exit

var in_air = false
var air_area_count = 0

func _physics_process(_delta: float) -> void:
	if in_air != (air_area_count > 0):
		if air_area_count > 0:
			air_enter.emit()
			in_air = true
		else:
			air_exit.emit()
			in_air = false
