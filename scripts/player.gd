extends CharacterBody2D

signal update_playerhealth

# Possibily TODO: Swap animated sprite to animation player and use animation tree
# https://www.youtube.com/watch?v=OUvpe9FMkLI

@onready var sprite : Sprite2D = $Sprite2D
@onready var animation_tree : AnimationTree = $AnimationTree
@onready var state_machine : CharacterStateMachine = $CharacterStateMachine
#==============================================================
# Need to confirm if this is correct practice to use global variables
#@export_enum(Globals.playerClass) var playerClass = Globals.playerClass
@export_range(0, 100) var playerHealth = Globals.playerHealth
@export var speed = Globals.playerSpeed
#===============================================================
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction: Vector2 = Vector2.ZERO

func _ready():
	var healthbar = get_tree().get_root().get_node("Game/GameOverlayUI/CanvasLayer/Healthbar")
	healthbar.init_health(Globals.playerHealth);
	animation_tree.active = true
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Get the input direction: -1, 0 or 1
	direction = Input.get_vector("left", "right", "up", "down")
	
	# Control wether or not to move
	if direction.x != 0 && state_machine.check_if_can_move():
		velocity.x = direction.x * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	# Update facing direction
	if direction.x > 0:
		sprite.flip_h = false
	elif direction.x < 0:
		sprite.flip_h = true
	
	move_and_slide()
	# Update animation parameters
	animation_tree.set("parameters/move/blend_position", direction.x)
	
# Auxiliary function for enemy scripts to check if this is the player Using: has_method("player")
func player() -> void:
	pass
	
func take_damage(damageAmount) -> void:
	Globals.playerHealth -= damageAmount
	sprite.play("damaged") 
	# This signal sends the new player health so the UI update itself (healthbar.gd)
	emit_signal("update_playerhealth", Globals.playerHealth)
	if Globals.playerHealth <= 0:
		Globals.coinsCollected = 0
		die()
	
func die() -> void:
	#sprite.play("death")
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
