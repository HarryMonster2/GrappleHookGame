extends Node
class_name Global_script

var current_scene = null
var packed_scenes : Dictionary
@onready var player = preload("res://Scenes/Player/PlayerHolder.tscn").instantiate()

func _ready():
	var root = get_tree().root
	current_scene = root.get_child(root.get_child_count() - 1)

func goto_scene(path):
	call_deferred("_deferred_goro_scene", path)

func _deferred_goro_scene(path):
	current_scene.queue_free()
	
	if packed_scenes.has(path):
		var to_instance = packed_scenes[path].instantiate()
		current_scene = to_instance
	else:
		var s = load(path)
		packed_scenes[path] = s
		var to_instance = packed_scenes[path].instantiate()
		current_scene = to_instance

	get_tree().root.add_child(current_scene)
	
	get_tree().current_scene = current_scene
