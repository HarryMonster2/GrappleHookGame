extends RigidBody2D
class_name Cult_Member

var panicing = false
var has_paniced = false
var melee_range = false
var run_away = false
var run_to = false

@export var range_obj_speed = 250
@export var range_obj : PackedScene

@onready var target = get_node("/root/Hold_Player/Player2d/Target")

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
@export var max_agro = 200
@export var melee_radius = 10
@export var range_radius = 160
@export var panic_radius = 50

@onready var radius_range = $rangeattack/CollisionShape2D
@onready var radius_melee = $meleerange/CollisionShape2D
@onready var radius_panic = $panicrange/CollisionShape2D
@onready var range_point = $attackpoint

@onready var csp_ray = $canseeplayer
@onready var range_attack = $rangeattack
@onready var melee_attack = $meleerange
@onready var panic_range = $panicrange

@onready var global = get_node("/root/Global")
@onready var player = get_node("/root/Hold_Player/Player2d")

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
			_panic()
			panicing = true
		elif has_paniced && !panic_range.overlaps_body(player) || melee_range:
			panicing = false
			has_paniced = false
		
		if range_attack.overlaps_body(player) && !melee_range && !panicing:
			_range_attack()
	#		-what to do-

func _melee_attack():
	#		-melee attack-
	if enemy_type == Enemy_Type.cult_blood_basic:
		print("blood melee")
	#		-melee attack-

func _range_attack():
	#		-range attack-
	if enemy_type == Enemy_Type.cult_blood_basic && !global.blood_cult_cooldown:
		global.blood_cult_cooldown = true
		var projectile = range_obj.instantiate()
		get_tree().current_scene.add_child(projectile)
		projectile.global_position = range_point.global_position
		var aimd : Vector2 = target.global_position - projectile.global_position
		projectile.linear_velocity = aimd.normalized() * range_obj_speed
		
	#		-range attack-

func _panic():
	#		-panic options-
	has_paniced = true
	if enemy_type == Enemy_Type.cult_blood_basic:
		var choice = randi_range(1, 3)
		print("blood panic")
		
		if choice <= 2:
			print("1")
		if choice == 3:
			print("2")
	#		-panic options-
