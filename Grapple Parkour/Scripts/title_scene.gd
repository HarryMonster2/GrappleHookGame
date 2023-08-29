extends Control
class_name title_scene

@onready var global = get_node("/root/Global")
@onready var player = preload("res://Scenes/Player/PlayerHolder.tscn").instantiate()

func _on_button_pressed():
	get_node("/root").add_child(player)
	global.goto_scene("res://Scenes/Levels/hub_world.tscn")
