extends RigidBody3D

var speed = 1
var followDistance = 3  # Adjust this value to set the desired follow distance
var followingPlayer = false

func _physics_process(delta):
	var player = $"../Player"  # Replace with the correct path to your player

	if player:
		var playerDistance = global_transform.origin.distance_to(player.global_transform.origin)

		if playerDistance <= followDistance:
			followingPlayer = true
			visible = false

		if followingPlayer:
			var direction = (player.global_transform.origin - global_transform.origin).normalized()
			var offset = direction * followDistance
			linear_velocity = direction * speed
			global_transform.origin += offset
