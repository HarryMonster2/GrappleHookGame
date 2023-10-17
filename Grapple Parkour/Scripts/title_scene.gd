extends Control
class_name title_scene

@onready var global = get_node("/root/Global")
@onready var player = preload("res://Scenes/Player/PlayerHolder.tscn").instantiate()

func _on_play_pressed(): #play
	get_node("/root").add_child(player)
	global.goto_scene("res://Scenes/Levels/hub_world.tscn")

func _on_quit_pressed(): #quit
	get_tree().quit()
