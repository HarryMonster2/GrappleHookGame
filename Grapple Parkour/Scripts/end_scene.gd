extends Control
class_name end_scene

@onready var global = get_node("/root/Global")

func _on_btm_pressed():
	global.goto_scene("res://Scenes/Levels/title_scene.tscn")
