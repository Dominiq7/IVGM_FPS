extends CharacterBody3D

var player = null
var state_machine
var health = 2

@export var player_path : NodePath
@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

const SPEED = 2.0
const ATTACK_RANGE = 2.0
const SIGHT = 10

signal ghost_hit

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")

func _process(delta):
	velocity = Vector3.ZERO
	
	match state_machine.get_current_node():
		"Run":
			nav_agent.set_target_position(player.global_transform.origin)
			var next_nav_point = nav_agent.get_next_path_position()
			velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
			rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, velocity.z), delta*10)
		"Attack":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
	
	anim_tree.set("parameters/conditions/run", _find_player())
	anim_tree.set("parameters/conditions/attack", _target_in_range())
	anim_tree.set("parameters/conditions/run", !_target_in_range())
	
	move_and_slide()

func _find_player():
	return global_position.distance_to(player.global_position) <= SIGHT

func _target_in_range():
	return global_position.distance_to(player.global_position) <= ATTACK_RANGE

func _hit_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		player.hit(dir)

func _on_area_3d_body_part_hit(dam):
	health -= dam
	if health > 0:
		anim_tree.set("parameters/conditions/ow", true)
		await get_tree().create_timer(0.8).timeout
		anim_tree.set("parameters/conditions/ow", false)
	if health <= 0:
		anim_tree.set("parameters/conditions/dead", true)
		await get_tree().create_timer(3.0).timeout
		queue_free()
