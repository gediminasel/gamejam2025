extends Node2D
class_name Bubble

const FrameLength = 1.0 / 4
const EnemiesGroup = "Enemies"

@onready var states = $States.get_children() as Array[StaticBody2D]

var velocity = Vector2(1, 1)

var active_state = 0
var next_change = FrameLength


func _ready() -> void:
	if velocity.x < 0:
		$States.scale.x = -1
	for s in states:
		var shape = s.get_node("CollisionShape2D") as CollisionShape2D
		shape.disabled = true
	states[0].get_node("CollisionShape2D").disabled = false

func _physics_process(delta: float) -> void:
	if next_change < 0:
		return
	next_change -= delta
	if next_change <= 0:
		states[active_state].visible = false
		states[active_state].get_node("CollisionShape2D").disabled = true

		active_state += 1
		if active_state >= len(states):
			queue_free()
			return
		states[active_state].visible = true
		states[active_state].get_node("CollisionShape2D").disabled = false
		next_change = FrameLength
	
	position += velocity * delta

func _on_collision(object: Node2D) -> void:
	if object.is_in_group("Player"):
		return
	if object.is_in_group(EnemiesGroup):
		var hit_by_bubble = object.get_node_or_null("HitByBubble")
		if hit_by_bubble is HitByBubble:
			hit_by_bubble.on_hit.emit()
	
	queue_free()
