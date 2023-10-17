extends Node2D
class_name level_select

@onready var player = get_node("/root/player holder/Player2d")
@onready var global = get_node("/root/Global")

func _on_l_1_pressed():
	global.goto_scene("res://Scenes/Levels/level#1.tscn")
	player.set_linear_velocity(Vector2(0, 0))
	player.global_position = Vector2(0, 0)
