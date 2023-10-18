extends StaticBody3D

@export var portal_path :NodePath
@export var player_path :NodePath

var portal
var player

const SHOW_RANGE = 10.0

func _ready():
	portal = get_node(portal_path)
	player = get_node(player_path)
	show()
	portal.hide()

func _process(delta):
	if _target_in_range():
		portal.show()
		hide()

func _target_in_range():
	return global_position.distance_to(player.global_position) < SHOW_RANGE
