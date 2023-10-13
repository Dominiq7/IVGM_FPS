extends CharacterBody3D

var player = null
var state_machine
var health = 4

const SPEED = 4.5
const ATTACK_RANGE = 2.0
const RUN_RANGE = 10.0

signal monster_hit

@export var player_path :NodePath # change it to your level player

@onready var nav_agent =$NavigationAgent3D
@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _process(delta):
	
	if global_position.distance_to(player.global_position) < RUN_RANGE:
		velocity = Vector3.ZERO
		match state_machine.get_current_node():
			"Run":
				# Navigation
				nav_agent.set_target_position(player.global_transform.origin)
				var next_nav_point = nav_agent.get_next_path_position()
				velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
				rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
				
			"Weapon":
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		
		# Conditions
		anim_tree.set("parameters/conditions/Attack", _target_in_range())
		anim_tree.set("parameters/conditions/Run", !_target_in_range())
		
		move_and_slide()
	
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)


func _on_area_3d_body_part_hit(dam):#enemy is attacked
	health -= dam
	emit_signal("monster_hit")
	if health <= 0:
		anim_tree.set("parameters/conditions/Die", true)
		await get_tree().create_timer(1.0).timeout
		queue_free()
