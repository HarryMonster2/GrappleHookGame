extends RigidBody2D

@onready var player = get_node("/root/player holder/Player2d")
@onready var cult = get_node("/root/level#1/blood cult basic")

func _on_body_entered(body):
	cult.attack_cooldown = false
	queue_free()
	var collwith = body
	if body.has_method("_health_manager"):
		player._health_manager(25)
