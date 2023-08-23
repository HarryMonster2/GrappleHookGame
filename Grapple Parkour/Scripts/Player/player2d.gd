extends RigidBody2D
class_name Player_guy

var grappling = false

@export var speed = 250
@export var jump = -250
@export var max_grapple = 150
@export var starter_health = 100

@onready var ray = $RayCast2D
@onready var onground = $onground
@onready var hart = $"Control/current health"

@onready var current_health :int = starter_health

@onready var global = get_node("/root/Global")

@onready var player_holder = get_node("/root/Hold_Player")
@onready var gchain = get_node("/root/Hold_Player/chain")
@onready var gpoint = get_node("/root/Hold_Player/Gpoint")
@onready var cpoint = get_node("/root/Hold_Player/Gpoint/cpoint")
@onready var player = get_node("/root/Hold_Player/Player2d")
@onready var damper = get_node("/root/Hold_Player/damper")

func _process(_delta):
	#		-grapple hook-	-] https://youtu.be/XhaCuXV99ds [-
	damper.global_position = player.global_position
	ray.look_at(get_global_mouse_position())
	gpoint.look_at(player.global_position)
	
	gchain.set_point_position(1, Vector2(player.global_position))
	gchain.set_point_position(0, Vector2(cpoint.global_position))

	if ray.is_colliding():
		ray.target_position.x = ray.get_collision_point().distance_to(ray.global_position)
	else:
		ray.target_position.x = max_grapple
	
	if Input.is_action_just_pressed("Grapple"):
		if ray.is_colliding():
			grappling = true
			
			var thingtostick = ray.get_collider()
			var distancelength = ray.get_collision_point().distance_to(player.global_position)
			
			gpoint.global_position = ray.get_collision_point()
			gchain.visible = true
			
			damper.length = distancelength
			damper.global_rotation_degrees = ray.global_rotation_degrees - 90
			damper.rest_length = distancelength * 0.75
			
			damper.node_b = thingtostick.get_path()
	if !Input.is_action_pressed("Grapple"):
		grappling = false
	if !grappling:
		gchain.visible = false
		damper.node_b = damper.node_a
		gpoint.global_position = player.global_position
	#		-grapple hook-	-] https://youtu.be/XhaCuXV99ds [-
	
	#		-health-
	hart.value = current_health
	if current_health <= 0:
		player.global_position = Vector2(0, 0)
		get_tree().change_scene_to_file("res://Scenes/Levels/hub_world.tscn")
	#		-health-
	
	#		-movement-
	var is_grounded = onground.has_overlapping_bodies()
	
	if Input.is_action_pressed("Move_Left") && !linear_velocity.x < -250:
		apply_central_force(Vector2(-speed, 0))
	
	if Input.is_action_pressed("Move_Right") && !linear_velocity.x > 250:
		apply_central_force(Vector2(speed, 0))
	
	if !Input.is_action_pressed("Move_Left") && !Input.is_action_pressed("Move_Right") && is_grounded && !grappling:
		linear_velocity.x = 0
	
	if Input.is_action_just_pressed("Jump") && is_grounded:
		linear_velocity.y = jump
	#		-movement-

func _health_manager():
	current_health -= 12
