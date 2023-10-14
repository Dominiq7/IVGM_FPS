extends RigidBody3D
class_name Crate

var is_lifting = false # Boolean idicating wether the crate is currently being lifted by the player ability

# Get the gravity from the project settings to be synced with other nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	if is_lifting:
		apply_central_force(Vector3.UP * 3)
		
		if $LiftTimer.time_left < 8.5:
			linear_velocity.y = 0
	else:
#		freeze = false
		linear_velocity.y -= gravity * delta


func set_is_lifting(value: bool):
	is_lifting = value
	
	if value:
		$LiftTimer.start()

func _on_lift_timer_timeout():
	set_is_lifting(false)
