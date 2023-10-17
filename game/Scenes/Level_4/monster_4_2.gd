extends CharacterBody3D


var player = null
var state_machine
var health = 4

const ATTACK_RANGE = 10.0

signal monster_hit

@export var player_path :NodePath # change it to your level player
@onready var anim_tree = $AnimationTree
@onready var enemy_barrel = $RayCast3D

# Bullets
var bullet2 = load("res://Scenes/Bullet/Bullet2.tscn")
var instance

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _process(delta):
	velocity = Vector3.ZERO
	if global_position.distance_to(player.global_position) < ATTACK_RANGE:
	
		match state_machine.get_current_node():
			"Idle":
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			"Bite_Front":
				look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
				# Handle Shooting
				instance = bullet2.instantiate()
				instance.position = enemy_barrel.global_position
				instance.transform.basis = enemy_barrel.global_transform.basis
				get_parent().add_child(instance)
	
	
	
		
		# Conditions
		anim_tree.set("parameters/conditions/attack2", _target_in_range())
		anim_tree.set("parameters/conditions/stay2", !_target_in_range())
		
		move_and_slide()
		
	
	
	
func _target_in_range():
	return global_position.distance_to(player.global_position) < ATTACK_RANGE
	
#func _hit_finished():# this need to change to bullet2 collide palyer body,then player.hit(dir)
#	if global_position.distance_to(player.global_position) < ATTACK_RANGE + 1.0:
#		var dir = global_position.direction_to(player.global_position)
#		player.hit(dir)


func _on_area_3d_body_part_hit(dam):
	health -= dam
	emit_signal("monster_hit")
	if health <= 0:
		anim_tree.set("parameters/conditions/die2", true)
		await get_tree().create_timer(1.0).timeout
		queue_free()

