extends RigidBody3D

var player
var deleteDistance = 2.0

func _ready():
	# Find and store a reference to the player node.
	player = $"../Player"  # Replace with the actual path to your player node.

func _process(delta):
	if player:
		# Calculate the distance between this node and the player.
		var distance = global_transform.origin.distance_to(player.global_transform.origin)
		
		# Check if the distance is less than the deleteDistance.
		if distance < deleteDistance:
			# Call a custom method to delete this node and its children.
			delete_self_and_children()

func delete_self_and_children():
	# Recursively delete this node and all its children.
	queue_free()
