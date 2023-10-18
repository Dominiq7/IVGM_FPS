extends Node3D

var player

# Called when the node enters the scene tree for the first time.
func _ready():
	player = $Player
	
	for sprite in $NavigationRegion3D/River/Water.get_children():
		sprite.play()
		
	await get_tree().create_timer(2.0).timeout
	$FirstPortal.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if player.global_position.y < -0.5:
		player.playerDied()
