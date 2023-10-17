extends RigidBody2D
class_name Cult_Member

var panic_choice
var panicing = false
var has_paniced = false
var melee_range = false
var range_range = false
var run_away = false
var run_to = false
var attack_cooldown = false
var touch_ground = false

@export var move_speed = 80
@export var enemy_starter_health = 100
@export var range_cool = 2
@export var melee_cool = 1
@export var range_obj_speed = 250
@export var range_obj : PackedScene
@export var melee_obj : PackedScene

@onready var current_enemy_health :int = enemy_starter_health
@onready var target = get_node("/root/player holder/Player2d/Target")

#		-cult selection-
@export_category("cult selection")
@export var enemy_type := Enemy_Type.cult_blood_basic
enum Enemy_Type
{
	#		-blood cult-
	cult_blood_basic,
	cult_blood_advanced,
	cult_blood_boss,
	#		-blood cult-
	#		-worm cult-
	cult_worm_basic, 
	cult_worm_advanced, 
	cult_worm_boss,
	#		-worm cult-
	#		-plant cult-
	cult_plant_basic, 
	cult_plant_advanced, 
	cult_plant_boss,
	#		-plant cult-
	#		-lightning cult-
	cult_lightning_basic, 
	cult_lightning_advanced, 
	cult_lightning_boss,
	#		-lightning cult-
	#		-magma cult-
	cult_magma_basic, 
	cult_magma_advanced, 
	cult_magma_boss,
	#		-magma cult-
	#		-the KKK-
	cult_KKK_basic, 
	cult_KKK_advanced, 
	cult_KKK_boss,
	#		-the KKK-
}
#		-cult selection-

@export_category("range state")
@export var max_agro = 325
@export var melee_radius = 18
@export var range_radius = 225
@export var panic_radius = 65

@onready var anim = $AnimationTree
@onready var radius_range = $rangeattack/CollisionShape2D
@onready var radius_melee = $meleerange/CollisionShape2D
@onready var radius_panic = $panicrange/CollisionShape2D
@onready var range_point = $attackpoint
@onready var atk_timer = $ATKtimer
@onready var sprite = $Sprite
@onready var csp_ray = $canseeplayer
@onready var range_attack = $rangeattack
@onready var melee_attack = $meleerange
@onready var panic_range = $panicrange

@onready var global = get_node("/root/Global")
@onready var player = get_node("/root/player holder/Player2d")

func _process(_delta):
	csp_ray.look_at(player.global_position)
	radius_range.shape.radius = range_radius
	radius_melee.shape.radius = melee_radius
	radius_panic.shape.radius = panic_radius
	
	if csp_ray.is_colliding():
		csp_ray.target_position.x = csp_ray.get_collision_point().distance_to(csp_ray.global_position)
	else:
		csp_ray.target_position.x = max_agro
	
	#		-what to do-
	if csp_ray.get_collider() == player:
		if melee_attack.overlaps_body(player):
			_melee_attack()
			melee_range = true
		else:
			melee_range = false
		
		if panic_range.overlaps_body(player) && !melee_range && !has_paniced:
			panicing = true
			var choice = randi_range(1, 3)
			panic_choice = choice
		elif !panic_range.overlaps_body(player) || melee_range:
			panicing = false
			has_paniced = false
		
		if range_attack.overlaps_body(player) && !melee_range && !panicing:
			_range_attack()
			range_range = true
		else:
			range_range = false
	#		-what to do-
		
	#		-health-
	if current_enemy_health <= 0:
		queue_free()
	#		-health-
	
	#		-movement-
	move()
	#		-movement-

func move():
	var my_vert_vel = get_linear_velocity().y
	
	if csp_ray.get_collider() == player:
		var dric = (player.global_position - global_position).normalized()
		if dric.x >0 && !melee_range && !panicing && !range_range && !has_paniced && touch_ground:
			set_linear_velocity(Vector2(1 * move_speed, my_vert_vel))
			anim.set("parameters/Transition/transition_request", "Run")
		elif dric.x < 0 && !melee_range && !panicing && !range_range && !has_paniced && touch_ground:
			set_linear_velocity(Vector2(-1 * move_speed, my_vert_vel))
			anim.set("parameters/Transition/transition_request", "Run")
		
		if dric.x >0:
			sprite.scale.x = 1
		elif dric.x < 0:
			sprite.scale.x = -1
	elif touch_ground:
		anim.set("parameters/Transition/transition_request", "Idle")
		set_linear_velocity(Vector2(0, my_vert_vel))
	
	if panicing && touch_ground:
		has_paniced = true
		if panic_choice <= 2:
			var dric = (player.global_position - global_position).normalized()
			if dric.x >0:
				set_linear_velocity(Vector2(1 * move_speed, my_vert_vel))
			elif dric.x < 0:
				set_linear_velocity(Vector2(-1 * move_speed, my_vert_vel))
		if panic_choice == 3:
			var dric = (player.global_position - global_position).normalized()
			if dric.x >0:
				set_linear_velocity(Vector2(-1 * move_speed, my_vert_vel))
			elif dric.x < 0:
				set_linear_velocity(Vector2(1 * move_speed, my_vert_vel))

func _melee_attack():
	#		-melee attack-
	if enemy_type == Enemy_Type.cult_blood_basic && !attack_cooldown:
		attack_cooldown = true
		atk_timer.wait_time = melee_cool
		atk_timer.start()
		var melee_swing = melee_obj.instantiate()
		add_child(melee_swing)
		var dric = (player.global_position - global_position).normalized()
		if dric.x < 0:
			melee_swing.scale.x *= -1
	#		-melee attack-

func _range_attack():
	#		-range attack-
	if enemy_type == Enemy_Type.cult_blood_basic && !attack_cooldown:
		anim.set("parameters/ATK/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
		attack_cooldown = true
		atk_timer.wait_time = range_cool
		atk_timer.start()
		var projectile = range_obj.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = range_point.global_position
		var aimd : Vector2 = target.global_position - projectile.global_position
		projectile.linear_velocity = aimd.normalized() * range_obj_speed
		
	#		-range attack-

func enemy_health(damage):
	current_enemy_health -= damage

func _on_at_ktimer_timeout():
	attack_cooldown = false

func _on_onground_body_entered(_onground):
	touch_ground = true

func _on_onground_body_exited(_onground):
	touch_ground = false
