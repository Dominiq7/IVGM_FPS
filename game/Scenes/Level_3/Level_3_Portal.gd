extends Area3D

var requiredRigidBodyPath: NodePath = "/root/Node3d/king"  # Update the path accordingly

func _on_body_entered(body):
	if body.is_in_group("Player"):
		var current_scene_file = get_tree().current_scene.scene_file_path
		var next_level_number = current_scene_file.to_int() + 1 # level name needs to have a number
		var next_level_path = "res://levels/Level_" + str(next_level_number) + ".tscn"
		var required_rigidbody = get_node(requiredRigidBodyPath)

		if required_rigidbody:
			if required_rigidbody is RigidBody3D and self.global_transform.origin.distance_to(required_rigidbody.global_transform.origin) <= 5:
				get_tree().change_scene(next_level_path)
		else:
			print("Required RigidBody not found or is null.")
