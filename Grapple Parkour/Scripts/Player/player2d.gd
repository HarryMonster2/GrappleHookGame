extends RigidBody2D
class_name Player_guy

var grappling = false 
var attacking = false
var touch_ground = true
var xpos = global_position.x

@export var speed = 100
@export var jump_force = 100

@export var max_grapple = 150
@export var starter_health = 100

@onready var sprite = $sprite
@onready var ray = $RayCast2D
@onready var onground = $onground
@onready var hart = $"Control/current health"
@onready var weapon = $"weapon holder"
@onready var anim = $AnimationPlayer

@onready var current_health :int = starter_health

@onready var global = get_node("/root/Global")
@onready var player_holder = get_node("/root/player holder")
@onready var gchain = get_node("/root/player holder/chain")
@onready var gpoint = get_node("/root/player holder/Gpoint")
@onready var cpoint = get_node("/root/player holder/Gpoint/cpoint")
@onready var player = get_node("/root/player holder/Player2d")
@onready var damper = get_node("/root/player holder/damper")

func _physics_process(delta):
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
	
	if Input.is_action_just_pressed("Grapple") && !attacking:
		if ray.is_colliding():
			grappling = true
			
			var thingtostick = ray.get_collider()
			var distancelength = ray.get_collision_point().distance_to(player.global_position)
			
			gpoint.global_position = ray.get_collision_point()
			gpoint.visible = true
			gchain.visible = true
			
			damper.length = distancelength
			damper.global_rotation_degrees = ray.global_rotation_degrees - 90
			damper.rest_length = distancelength * 0.75
			
			damper.node_b = thingtostick.get_path()
	
	if !Input.is_action_pressed("Grapple"):
		grappling = false
		damper.node_b = damper.node_a
		gpoint.global_position = player.global_position
		gchain.visible = false
		gpoint.visible = false
	#		-grapple hook-	-] https://youtu.be/XhaCuXV99ds [-
	
	#		-health-
	hart.value = current_health
	if current_health <= 0:
		current_health = starter_health
		set_linear_velocity(Vector2(0, 0))
		player.global_position = Vector2(0, 0)
		global.goto_scene("res://Scenes/Levels/hub_world.tscn")
	#		-health-
	
	#		-attack-
	attack()
	#		-attack-
	
	#		-movement-
	move()
	#		-movement-

func _health_manager(damage_amount):
	current_health -= damage_amount

func attack():
	if Input.is_action_just_pressed("Attack") && !grappling && !attacking:
		attacking = true
		weapon.look_at(get_global_mouse_position())
		anim.set_current_animation("chainknifeatk")
	elif !anim.is_playing():
		attacking = false
		anim.set_current_animation("RESET")

func move():
	var my_vert_vel = get_linear_velocity().y
	
	if Input.is_action_pressed("Move_Right"):
		set_linear_velocity(Vector2(1 * speed, my_vert_vel))
		xpos = global_position.x
		sprite.scale.x = 1
	elif Input.is_action_pressed("Move_Left"):
		set_linear_velocity(Vector2(-1 * speed, my_vert_vel))
		xpos = global_position.x
		sprite.scale.x = -1
	elif touch_ground:
		global_position.x = xpos
		set_linear_velocity(Vector2(0, my_vert_vel))
	
	if Input.is_action_pressed("Jump") && touch_ground:
		apply_impulse(Vector2(0, -1 * jump_force))

func _on_onground_body_entered(onground):
	touch_ground = true
	xpos = global_position.x

func _on_onground_body_exited(onground):
	touch_ground = false

func _on_chainknifehold_body_entered(chainknife):
	attacking = false
	anim.set_current_animation("RESET")
	var collwith = chainknife
	if collwith.has_method("enemy_health"):
		collwith.enemy_health(50)
