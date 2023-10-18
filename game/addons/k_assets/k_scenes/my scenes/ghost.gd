extends Node3D


var movement = 0.25
var upward = true

var s_pos 
var e_pos   
var rng = RandomNumberGenerator.new()
var my_random_number = rng.randf_range(5, 30)

func _ready():
	upward = true 
	s_pos = transform.origin.y
	e_pos = transform.origin.y + my_random_number

func _process(_delta):
	if upward:
		transform.origin.y += movement
	if not upward:
		transform.origin.y -= movement
	if transform.origin.y >= e_pos:
		upward = false 
	if transform.origin.y <= s_pos:
		upward = true



 
