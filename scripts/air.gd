extends Area2D


func _on_body_entered(body: Node2D) -> void:
	var in_air = body.get_node_or_null("InAir")
	if in_air is InAir:
		in_air.air_area_count += 1


func _on_body_exited(body: Node2D) -> void:
	var in_air = body.get_node_or_null("InAir")
	if in_air is InAir:
		in_air.air_area_count -= 1


func _on_area_entered(area: Area2D) -> void:
	var in_air = area.get_node_or_null("InAir")
	if in_air is InAir:
		in_air.air_area_count += 1


func _on_area_exited(area: Area2D) -> void:
	var in_air = area.get_node_or_null("InAir")
	if in_air is InAir:
		in_air.air_area_count -= 1
