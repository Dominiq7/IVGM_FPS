extends StaticBody3D

var is_lifting = false
var is_breaking = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Log.show()
	$LogPiece1.show()
	$LogPiece2.hide()
	$LogPiece3.hide()
	$LogPiece4.hide()
	$LogPiece5.show()
	$LogPiece6.hide()
	$LogPiece7.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _physics_process(delta):
	
	if is_breaking:
		$Log.hide()
		$LogPiece1.show()
		$LogPiece2.show()
		$LogPiece3.show()
		$LogPiece4.show()
		$LogPiece5.show()
		$LogPiece6.show()
		$LogPiece7.show()
		position += Vector3(0, 0.01, 0)
		await get_tree().create_timer(1.5).timeout
		queue_free()

	
	if is_lifting:
		if $BreakLogTimer.is_stopped():
			$BreakLogTimer.start()
		
		position += Vector3(0, 0.025, 0)

func set_is_lifting(value):
	is_lifting = value

func _on_break_log_timer_timeout():	
	is_breaking = true
