extends CharacterBody3D


var player = null
var state_machine
var health = 2

signal king_die

@export var player_path :NodePath # change it to your level player

@onready var anim_tree = $AnimationTree

func _ready():
	player = get_node(player_path)
	state_machine = anim_tree.get("parameters/playback")
	
func _process(delta):
	

	velocity = Vector3.ZERO
	match state_machine.get_current_node():
		"flight":
			look_at(Vector3(player.global_position.x, global_position.y, player.global_position.z), Vector3.UP)
			


func _on_area_3d_body_part_hit(dam):#enemy is attacked
	health -= dam
	print(1)
	if health <= 0:
		anim_tree.set("parameters/conditions/die4", true)
		emit_signal("king_die")
		await get_tree().create_timer(1.0).timeout
		queue_free()
