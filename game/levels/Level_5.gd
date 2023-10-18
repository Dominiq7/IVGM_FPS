extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for sprite in $NavigationRegion3D/River/Water.get_children():
		sprite.play()
		
	await get_tree().create_timer(2.0).timeout
	$FirstPortal.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
