extends RigidBody2D
class_name Player_guy

var grappling = false 
var touch_ground = true

@export var speed = 200
@export var jump_force = 50

@export var max_grapple = 150
@export var starter_health = 100

@onready var ray = $RayCast2D
@onready var onground = $onground
@onready var hart = $"Control/current health"

@onready var current_health :int = starter_health

@onready var global = get_node("/root/Global")

@onready var player_holder = get_node("/root/player holder")
@onready var gchain = get_node("/root/player holder/chain")
@onready var gpoint = get_node("/root/player holder/Gpoint")
@onready var cpoint = get_node("/root/player holder/Gpoint/cpoint")
@onready var player = get_node("/root/player holder/Player2d")
@onready var damper = get_node("/root/player holder/damper")

func _physics_process(_delta):
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
	move()
	#		-movement-

func _health_manager():
	current_health -= 12

func move():
	var my_vert_vel = get_linear_velocity().y
	
	if Input.is_action_pressed("Move_Right"):
		set_linear_velocity(Vector2(1 * speed, my_vert_vel))
	elif Input.is_action_pressed("Move_Left"):
		set_linear_velocity(Vector2(-1 * speed, my_vert_vel))
	elif touch_ground: 
		set_linear_velocity(Vector2(0, my_vert_vel))
		
	if Input.is_action_pressed("Jump") && touch_ground:
		apply_impulse(Vector2(0, -1 * jump_force))

func _on_onground_body_entered(onground):
	touch_ground = true

func _on_onground_body_exited(onground):
	touch_ground = false
