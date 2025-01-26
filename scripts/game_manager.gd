extends Node
class_name GameManager

static var Me = preload("res://GameManager.tscn")
static var Start = preload("res://ui/Start.tscn")
static var TheEnd = preload("res://stages/TheEnd.tscn")
static var Levels: Array[Resource] = [
	preload("res://stages/Stage1.tscn"),
]

var level = -1

static func instance(obj: Node) -> GameManager:
	var gm = obj.get_tree().root.get_node_or_null("GameManager") as GameManager
	if gm == null:
		gm = Me.instantiate() as GameManager
		obj.get_tree().root.add_child(gm)
		var current_scene_path = obj.get_tree().current_scene.scene_file_path
		for i in range(len(Levels)):
			if Levels[i].resource_path == current_scene_path:
				gm.level = i
	return gm

func start_game():
	level = 0
	get_tree().change_scene_to_packed(Levels[0])

func start_menu():
	level = -1
	get_tree().change_scene_to_packed(Start)

func retry():
	if level >= 0 and level < len(Levels):
		get_tree().change_scene_to_packed(Levels[level])

func next_level():
	level += 1
	if level < len(Levels):
		get_tree().call_deferred("change_scene_to_packed", Levels[level])
	else:
		get_tree().call_deferred("change_scene_to_packed", TheEnd)
