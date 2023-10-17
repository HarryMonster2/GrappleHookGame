extends RigidBody2D

@export var damage = 25

func _on_body_entered(body):
	queue_free()
#	var collwith = body
	if body.has_method("_health_manager"):
		body._health_manager(damage)

func _on_timer_timeout():
	queue_free()
