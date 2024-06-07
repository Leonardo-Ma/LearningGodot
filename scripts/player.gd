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
	elif (Input.is_action_just_pressed("attack")):
		animation_tree.set("parameters/ground_attack/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
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
		$Sprite2D/HitBox/CollisionShape2D.position.x = 49 # Read _BUG_ tag below
		$CollisionShape2D.position.x = 12 # Read _BUG_ tag below
	elif direction.x < 0:
		sprite.flip_h = true
		$Sprite2D/HitBox/CollisionShape2D.position.x = -3 # Read _BUG_ tag below
		$CollisionShape2D.position.x = 30 # Read _BUG_ tag below
	
	# BUG For the future me to fix and use this instead to flip the whole player:
	# https://www.reddit.com/r/godot/comments/jfbwzm/how_do_i_flip_a_collision_shape_2d_along_with_the/
	#if direction.x > 0:
		#scale.x = 1
	#elif direction.x < 0:
		#scale.x *= -1
		
	move_and_slide()
	
# Auxiliary function for enemy scripts to check if this is the player Using: has_method("player")
func player():
	pass
	
func take_damage(damageAmount):
	Globals.playerHealth -= damageAmount
	animation_tree.set("parameters/is_damaged/request", AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE)
	# This signal sends the new player health so the UI update itself (healthbar.gd)
	emit_signal("update_playerhealth", Globals.playerHealth)
	if Globals.playerHealth <= 0:
		die()
	
func die():
	$AnimationPlayer.play("death") # TODO Place logic in animation tree and use it instead
	# TODO Force finish animation before reloading scene
	get_tree().call_deferred("reload_current_scene")
	Globals.resetValues()
	request_ready()
	
	# Recall the player's ready function so every time the player dies, the healthbar
	# is also restarted (Healthbar is queued free if health == 0)
	
# TODO Transform this into a signal to avoid code duplication
func _on_slime_2_damage(damageAmount):
	take_damage(damageAmount)
	
func _on_slime_damage(damageValue):
	take_damage(damageValue)
