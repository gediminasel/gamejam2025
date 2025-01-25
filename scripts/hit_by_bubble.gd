extends Node
class_name HitByBubble

signal on_hit

func hit():
	on_hit.emit()
