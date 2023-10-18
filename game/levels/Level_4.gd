extends Node3D

@onready var hit_rect = $ui/ColorRect
@onready var text1 = $Control/Label
@onready var text2 = $Control/Label2


# Called when the node enters the scene tree for the first time.
func _ready():
	
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_player_hit():# player is attacked, view become red
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false


func _on_player_player_hit_2():
	hit_rect.visible = true
	await get_tree().create_timer(0.2).timeout
	hit_rect.visible = false 

#
func _on_area_3d_body_entered(body):
	text1.visible = true
	await get_tree().create_timer(1).timeout
	text1.visible = false 
	text2.visible = true
	await get_tree().create_timer(2.5).timeout
	text2.visible = false 


