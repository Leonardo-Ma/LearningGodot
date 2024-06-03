extends CharacterBody2D

signal update_playerhealth

const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Possibily TODO: Swap animated sprite to animation player and use animation tree
# https://www.youtube.com/watch?v=OUvpe9FMkLI
@onready var animated_sprite = $AnimatedSprite2D

#==============================================================
# Need to confirm if this is correct practice to use global variables
#@export_enum(Globals.playerClass) var playerClass = Globals.playerClass
@export_range(0, 100) var playerHealth = Globals.playerHealth
@export var SPEED = Globals.playerSpeed
#===============================================================
	
func _ready():
	var healthbar = get_tree().get_root().get_node("Game/GameOverlayUI/CanvasLayer/Healthbar")
	healthbar.init_health(Globals.playerHealth);
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	

	# Get the input direction: -1, 0 or 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animation
	if is_on_floor():
		# BUG Idle animation overriding attack animation
		if Input.is_action_just_pressed("attack"):
			animated_sprite.play("attack")
		if Input.is_action_just_pressed("jump"):
			velocity.y = JUMP_VELOCITY
		if direction == 0:
			animated_sprite.play("idle")
		else:
			animated_sprite.play("run")
	else:
		animated_sprite.play("jump")
		
	# Apply movement
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
# Auxiliary function for enemy scripts to check if this is the player Using: has_method("player")
func player() -> void:
	pass
	
func take_damage(damageAmount) -> void:
	Globals.playerHealth -= damageAmount
	animated_sprite.play("damaged")
	# This signal sends the new player health so the UI update itself (healthbar.gd)
	emit_signal("update_playerhealth", Globals.playerHealth)
	if Globals.playerHealth <= 0:
		Globals.coinsCollected = 0
		die()
	
func die() -> void:
	animated_sprite.play("death")
	get_tree().reload_current_scene()
	Globals.playerHealth = 100
	Globals.coinsCollected = 0
	request_ready()
	
	# Recall the player's ready function so every time the player dies, the healthbar
	# is also restarted (Healthbar is queued free if health == 0)
	
# TODO Transform this into a signal to avoid code duplication
func _on_slime_2_damage(damageAmount):
	take_damage(damageAmount)
	
func _on_slime_damage(damageValue):
	take_damage(damageValue)
