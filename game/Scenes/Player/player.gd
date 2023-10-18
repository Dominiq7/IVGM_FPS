extends CharacterBody3D

@onready var povRay = $Head/Camera3d/RayCast3d as RayCast3D
@onready var Cam = $Head/Camera3d as Camera3D
@onready var gun_anim =$Head/Camera3d/wand/AnimationPlayer
@onready var gun_barrel = $Head/Camera3d/wand/RayCast3D

const WALK_SPEED = 5.0
const SPRINT_SPEED = 10.0
const JUMP_VELOCITY = 8
const HIT_STAGGER = 8.0

var mouseSensibility = 1200
var mouse_relative_x = 0
var mouse_relative_y = 0
var speed = WALK_SPEED

var killed_enemies_level_1

# signal
signal player_hit
signal player_hit2

# Bullets
var bullet = load("res://Scenes/Bullet/Bullet.tscn")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	#Captures mouse and stops rgun from hitting yourself
	#povRay.add_exception(self)
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	$Ability/Icon.visible = true
	$Ability/CooldownTimerLabel.visible = false
	$Ability.modulate = Color(1, 1, 1, 1)
	$Ability/CooldownTimerLabel.modulate = Color(1, 1, 1, 0.5)
	killed_enemies_level_1 = 0
	
func _process(delta):
	
	# If ability not on cooldown
	if $Ability/CooldownTimer.is_stopped():
		$Ability/Outline.modulate = Color(1, 1, 1, 1)
		$Ability/Icon.visible = true
		$Ability/CooldownTimerLabel.visible = false
	else:
		$Ability/Outline.modulate = Color(1, 1, 1, 0.5)
		$Ability/Icon.visible = false
		$Ability/CooldownTimerLabel.visible = true
		
		# Ability cooldown timer display
		var int_time_left = int(round($Ability/CooldownTimer.time_left))
		$Ability/CooldownTimerLabel.text = "%s" % (int_time_left+1)
	
	if not $Ability/FlashRedTimer.is_stopped():
		$Ability.modulate = Color(0.878, 0.267, 0.36, 1)
	else:
		$Ability.modulate = Color(1, 1, 1, 1)
		
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
		shoot()
			
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

func shoot():
	if !gun_anim.is_playing():
		gun_anim.play("shoot")
		var bulletInstance = bullet.instantiate()
		bulletInstance.position = gun_barrel.global_position
		bulletInstance.transform.basis = gun_barrel.global_transform.basis
		get_parent().add_child(bulletInstance)

func cast_spell():
	
	# If ability is on cooldown prevent ability from being used
	if not $Ability/CooldownTimer.is_stopped():
		$Ability/FlashRedTimer.start()
		return
	
	if not povRay.is_colliding():
		$Ability/FlashRedTimer.start()
		return
	
	var selectedObject = povRay.get_collider()
	if selectedObject != null and selectedObject.get_groups().has("Liftable"):
		selectedObject.set_is_lifting(true)
		$Ability/CooldownTimer.start()
	else:
		$Ability/FlashRedTimer.start()
		
func hit(dir):# player is attacked by melee enemy
	emit_signal("player_hit")
	velocity += dir * HIT_STAGGER
	if velocity.length() > SPRINT_SPEED:
		velocity = velocity.normalized() * SPRINT_SPEED
		
func hit2():# player is attacked by ranged enemy
	emit_signal("player_hit2")

		
################################################################################
#new function: Player died, u can call this func to make new condition/function to make the player dies like Leaving the designated zone
func playerDied():
	get_tree().reload_current_scene()
################################################################################
	


func _on_monster_4_2_monster_hit():
	killed_enemies_level_1 += 1
