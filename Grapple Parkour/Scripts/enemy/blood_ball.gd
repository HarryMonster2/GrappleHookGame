extends RigidBody2D

@onready var player = get_node("/root/Hold_Player/Player2d")
@onready var global = get_node("/root/Global")

func _on_body_entered(body):
	global.blood_cult_cooldown = false
	queue_free()
	if body == player:
		player._health_manager()
