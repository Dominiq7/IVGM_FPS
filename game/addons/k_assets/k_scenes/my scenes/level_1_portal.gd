extends Node3D
@export var next_level_path = "res://levels/Level_2.tscn" # need to be changed
@export var timer = 5000 
var requested_time


func _ready():
	requested_time = 0

func _process(delta):
	requested_time += 1
	

func _on_area_3d_2_body_entered(body):
	if body.name == "Player":
		
		print(requested_time )
		print( timer)
		
		if requested_time >= timer:
			get_tree().change_scene_to_file(next_level_path)

