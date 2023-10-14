extends Node3D

var animation_player: AnimationPlayer
var original_position: Vector3
var floating_amplitude: float = 2.0
var floating_speed: float = 1.0
var last_time

func _ready():
	animation_player = $AnimationPlayer
	original_position = transform.origin
	animation_player.play("Float")
	last_time = Time.get_time_dict_from_system()

func _process(delta):
	var current_time = Time.get_time_dict_from_system()
	var time_passed = current_time - last_time
	last_time = current_time

	# Continuously update the object's position based on a sine wave for floating effect
	var offset = Vector3(0, sin(time_passed * floating_speed / 1000000.0) * floating_amplitude, 0)
	transform.origin = original_position + offset







