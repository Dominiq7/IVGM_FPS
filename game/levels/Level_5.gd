extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	for sprite in $Water.get_children():
		sprite.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
