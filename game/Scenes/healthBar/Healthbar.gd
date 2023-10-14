extends ProgressBar

const MAX_HEALTH = 1000
var health = MAX_HEALTH


func _ready() -> void:
  update_health_ui()
  self.max_value = MAX_HEALTH
  

func update_health_ui():
  set_health_bar()

func set_health_bar() -> void:
  self.value = health

#func _input(event: InputEvent) -> void:
#  if event.is_action_pressed("health_test_button"):damage()

func damage() -> void:
   pass
#  health -= 1
#  update_health_ui() 
#  if health < 0 :get_tree().reload_current_scene() #h we can reset our level


func _on_player_player_hit():
  health -= 250
  update_health_ui() 
  if health < 0 :get_tree().reload_current_scene() #h we can reset our level



func _on_player_player_hit_2():
  health -= 1
  update_health_ui() 
  if health < 0 :get_tree().reload_current_scene()
