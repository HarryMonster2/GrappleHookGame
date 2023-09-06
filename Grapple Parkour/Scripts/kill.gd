extends Area2D

@onready var player = get_node("/root/player holder/Player2d")

func _on_body_entered(body):
	if body == player:
		player.current_health = 0
