extends CharacterBody3D


var player = null
var state_machine
var health = 4
#var enemy_reach : bool = false
var speed = 3



const ATTACK_RANGE = 20.0

signal monster_hit

@export var player_path :NodePath # change it to your level player
@onready var anim_tree = $AnimationTree
@onready var enemy_barrel = $RayCast3D
#@onready var spotlight = $SpotLight3D
@onready var pathfollow = get_parent()

# Bullets
var bullet3 = load("res://Scenes/Bullet/Bullet3.tscn")
var instance

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _process(delta):
	velocity = Vector3.ZERO
	
	if global_position.distance_to(player.global_position) < ATTACK_RANGE:
	
		match state_machine.get_current_node():
			"Fast_Flying":
				_patrol(delta)
				
			"HitReact":
#				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
				# Handle Shooting
				instance = bullet3.instantiate()
				instance.position = enemy_barrel.global_position
				instance.transform.basis = enemy_barrel.global_transform.basis
				get_parent().add_child(instance)
	
	
	
		
		# Conditions
		anim_tree.set("parameters/conditions/attack3", _target_in_range())
		anim_tree.set("parameters/conditions/stay3", !_target_in_range())
		
#		move_and_slide()
		
func _patrol(delta):
	pathfollow.progress += speed * delta	
	
	
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	




