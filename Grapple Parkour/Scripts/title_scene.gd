extends Control
class_name title_scene

@onready var player = get_node("/root/Hold_Player/Player2d")

func _ready():
	player.freeze = true
	player.visible = false

func _on_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/Levels/hub_world.tscn")
	player.freeze = false
	player.visible = true
