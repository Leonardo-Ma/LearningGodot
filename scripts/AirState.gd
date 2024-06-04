extends State

class_name AirState

@export var landing_state : State
@export var double_jump_velocity : float = -200
@export var landing_animation : String = "jump_end"

func state_process(_delta):
	if(character.is_on_floor()):
		next_state = landing_state

func on_exit():
	if(next_state == landing_state):
		playback.travel(landing_animation)
