extends CharacterBody3D

@onready var povRay = $Head/Camera3d/RayCast3d as RayCast3D
@onready var Cam = $Head/Camera3d as Camera3D
@export var _bullet_scene : PackedScene
@onready var gun_anim =$Head/Camera3d/wand/AnimationPlayer
@onready var gun_barrel = $Head/Camera3d/wand/RayCast3D

var mouseSensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0
var speed
const WALK_SPEED = 5.0
const SPRINT_SPEED = 20.0
const JUMP_VELOCITY = 4.5
const HIT_STAGGER = 8.0

# signal
signal player_hit

# Bullets
var bullet = load("res://Scenes/Bullet/Bullet.tscn")
var instance

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#Captures mouse and stops rgun from hitting yourself
	#povRay.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle Sprint.
	if Input.is_action_pressed("sprint"):
		speed = SPRINT_SPEED
	else:
		speed = WALK_SPEED
	
	# Handle Shooting
	if Input.is_action_just_pressed("Shoot"):
#		shoot()
		if !gun_anim.is_playing():
			gun_anim.play("shoot")
			instance = bullet.instantiate()
			instance.position = gun_barrel.global_position
			instance.transform.basis = gun_barrel.global_transform.basis
			get_parent().add_child(instance)
			
	# Get the input direction and handle the movement/deceleration.
	var input_dir = Input.get_vector("moveLeft", "moveRight", "moveUp", "moveDown")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	# Handle Ability
	if Input.is_action_just_pressed("Ability"):
		cast_spell()

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		rotation.y -= event.relative.x / mouseSensibility
		$Head/Camera3d.rotation.x -= event.relative.y / mouseSensibility
		$Head/Camera3d.rotation.x = clamp($Head/Camera3d.rotation.x, deg_to_rad(-90), deg_to_rad(90) )
		mouse_relative_x = clamp(event.relative.x, -50, 50)
		mouse_relative_y = clamp(event.relative.y, -50, 10)

#func shoot():
#	if not povRay.is_colliding():
#		return
#	var bulletInst = _bullet_scene.instantiate() as Node3D
#	bulletInst.set_as_top_level(true)
#	get_parent().add_child(bulletInst)
#	bulletInst.global_transform.origin = povRay.get_collision_point() as Vector3
#	bulletInst.look_at((povRay.get_collision_point()+povRay.get_collision_normal()),Vector3.BACK)
#	print(povRay.get_collision_point())
#	print(povRay.get_collision_point()+povRay.get_collision_normal())

func cast_spell():
#	if not povRay.is_colliding():
#		return
	
	var selectedObject = povRay.get_collider()
	print(selectedObject.get_class())
	if selectedObject != null and selectedObject.get_class() == "RigidBody3D":
		selectedObject.set_is_lifting(true)
		
		
func hit(dir):
	emit_signal("player_hit")
	velocity += dir * HIT_STAGGER
	if velocity.length() > SPRINT_SPEED:
		velocity = velocity.normalized() * SPRINT_SPEED
	
