extends Area2D
class_name level_select

var select_entered = false

@onready var player = get_node("/root/player holder/Player2d")
@onready var global = get_node("/root/Global")

func _process(delta):
	if select_entered && Input.is_action_just_pressed("Interact"):
		global.goto_scene("res://Scenes/Levels/level#1.tscn")
		player.global_position = Vector2(0, 0)

func _on_body_entered(body):
	select_entered = true

func _on_body_exited(body):
	select_entered = false
