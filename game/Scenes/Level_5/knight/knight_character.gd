extends CharacterBody3D

var player = null
var state_machine
var health = 4

const SPEED = 4.5
const ATTACK_RANGE = 2.0
const RUN_RANGE = 10.0

@export var player_path :NodePath # change it to your level player

@onready var nav_agent = $NavigationAgent3D
@onready var anim_tree = $AnimationTree

# Called when the node enters the scene tree for the first time.
func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if global_position.distance_to(player.global_position) < RUN_RANGE:
		
		velocity = Vector3.ZERO
		match state_machine.get_current_node():
			"Run":
				# Navigation
				var playerPos = player.global_transform.origin
				playerPos.y = global_position.y
				
				nav_agent.set_target_position(Vector3(playerPos.x, global_position.y, playerPos.z))
				var next_nav_point = nav_agent.get_next_path_position()
				velocity = (next_nav_point - global_transform.origin).normalized() * SPEED
				rotation.y = lerp_angle(rotation.y, atan2(-velocity.x, -velocity.z), delta * 10.0)
			
			"Attack":
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
		
		# Conditions
		anim_tree.set("parameters/conditions/Attack", _target_in_range())
		anim_tree.set("parameters/conditions/Run", !_target_in_range())
		anim_tree.set("parameters/conditions/Idle", false)
		
		move_and_slide()
	else:
		anim_tree.set("parameters/conditions/Attack", false)
		anim_tree.set("parameters/conditions/Run", false)
		anim_tree.set("parameters/conditions/Idle", true)

func _attack_animation_finished():
	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
		var dir = global_position.direction_to(player.global_position)
		dir.y = dir.y - 1
		player.hit(dir)

func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
func hit():
	health -= 1
	if health <= 0:
		anim_tree.set("parameters/conditions/Die", true)
		await get_tree().create_timer(2.0833).timeout
		queue_free()
