# https://www.youtube.com/watch?v=f90ieBOoIYQ
extends ProgressBar

@onready var timer = $Timer
@onready var damagebar = $Damagebar

func _ready():
	# https://forum.godotengine.org/t/how-to-get-node-from-another-scene/30276/4
	var player = get_tree().get_root().get_node("Game/Player")
	# Healthbar is initialized in player.gd
	player.connect("update_playerhealth", Callable(self, "_set_health"))

# TODO Maybe change to directly use global values
# When this var receives a value, it instantiates the setter
var health: int = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	value = health
	
	if health <= 0:
		queue_free()
		
	if health < prev_health:
		timer.start()
	else:
		damagebar.value = health

	
func init_health(_health):
	health = _health
	max_value = health
	value = health
	damagebar.max_value = health
	damagebar.value = health

func _on_timer_timeout():
	damagebar.value = health
