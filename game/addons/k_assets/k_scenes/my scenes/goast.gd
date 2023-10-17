extends Node3D

var upward = true
var step_size = 0.25
var start 
var end    
var rng = RandomNumberGenerator.new()
var my_random_number = rng.randf_range(5, 30)

func _ready():
	upward = true 
	start = transform.origin.y
	end = transform.origin.y + my_random_number

func _process(_delta):
	if upward:
		transform.origin.y += step_size
	if not upward:
		transform.origin.y -= step_size
	if transform.origin.y >= end:
		upward = false 
	if transform.origin.y <= start:
		upward = true



 
