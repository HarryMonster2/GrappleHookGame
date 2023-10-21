extends Control
class_name title_scene

@onready var global = get_node("/root/Global")
@onready var player = preload("res://Scenes/Player/PlayerHolder.tscn").instantiate()
@onready var settings = $Settings2
@onready var credits = $Credits2
@onready var sb = $Settings
@onready var cb = $Credits

func _on_play_pressed(): #play
	get_node("/root").add_child(player)
	global.goto_scene("res://Scenes/Levels/hub_world.tscn")
	
func _on_credits_toggled(button_pressed):
	if button_pressed:
		credits.visible = true
		sb.button_pressed = false
	else:
		credits.visible = false

func _on_settings_toggled(button_pressed):
	if button_pressed:
		settings.visible = true
		cb.button_pressed = false
	else:
		settings.visible = false

func _on_quit_pressed(): #quit
	get_tree().quit()
