extends Node2D

@export var damage = 50

func _on_body_entered(body):
	queue_free()
	var collwith = body
	if body.has_method("_health_manager"):
		body._health_manager(damage)

func _on_animation_player_animation_finished(anim_name):
	queue_free()
