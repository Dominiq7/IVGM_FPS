extends Area3D


func _on_body_entered(body):
	if body.is_in_group("Player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1 #level name need have number
		var next_level_path = "res://levels/Level_" + str(next_level_number) + ".tscn"
		get_tree().change_scene_to_file(next_level_path)
