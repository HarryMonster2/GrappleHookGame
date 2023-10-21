extends Area2D
class_name win_select

@onready var player = get_node("/root/player holder/Player2d")
@onready var global = get_node("/root/Global")
@onready var WB = $Control/Win

func _on_button_pressed():
	global.goto_scene("res://Scenes/Levels/end_scene.tscn")
	player.queue_free()


func _on_body_entered(body):
	if body == player:
		WB.disabled = false
