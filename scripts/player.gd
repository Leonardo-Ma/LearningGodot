extends CharacterBody2D

signal update_playerhealth

const JUMP_VELOCITY = -300

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
#==============================================================
# Need to confirm if this is correct practice to use global variables
#@export_enum(Globals.playerClass) var playerClass = Globals.playerClass
@export_range(0, 100) var playerHealth = Globals.playerHealth
@export var speed = Globals.playerSpeed
#===============================================================
# Get the gravity from the project settings to be synced with RigidBody nodes
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO

func _ready():
	var healthbar = get_tree().get_root().get_node("Game/GameOverlayUI/Healthbar")
	healthbar.init_health(Globals.playerHealth);
	animation_tree.active = true
	
func _physics_process(delta):
	# Add the gravity
	if not is_on_floor():
		animation_tree.set("parameters/in_air_state/transition_request", "air")
		velocity.y += gravity * delta
	# If character is on floor and pressed jump
	elif (Input.is_action_just_pressed("jump")):
		velocity.y = JUMP_VELOCITY
		animation_tree.set("parameters/in_air/transition_request", "jumping") # Trigger jump animation)
	else:
		animation_tree.set("parameters/in_air_state/transition_request", "ground")
	
	# Get the input direction: -1, 0 or 1
	direction = Input.get_vector("left", "right", "up", "down")
	
	# Control wether or not to move
	if direction.x != 0:
		velocity.x = direction.x * speed
		animation_tree.set("parameters/movement/transition_request", "run") # Trigger run animation
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		animation_tree.set("parameters/movement/transition_request", "idle") # Trigger idle animation	
	
	# Update facing direction
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
		
	move_and_slide()
	
# Auxiliary function for enemy scripts to check if this is the player Using: has_method("player")
func player():
	pass
	
func take_damage(damageAmount):
	Globals.playerHealth -= damageAmount
	$AnimationPlayer.play("damaged") 
	# This signal sends the new player health so the UI update itself (healthbar.gd)
	emit_signal("update_playerhealth", Globals.playerHealth)
	if Globals.playerHealth <= 0:
		die()
	
func die():
	$AnimationPlayer.play("death")
	get_tree().reload_current_scene()
	Globals.resetValues()
	request_ready()
	
	# Recall the player's ready function so every time the player dies, the healthbar
	# is also restarted (Healthbar is queued free if health == 0)
	
# TODO Transform this into a signal to avoid code duplication
func _on_slime_2_damage(damageAmount):
	take_damage(damageAmount)
	
func _on_slime_damage(damageValue):
	take_damage(damageValue)
