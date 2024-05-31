extends CharacterBody2D

const JUMP_VELOCITY = -300.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animated_sprite = $AnimatedSprite2D

#==============================================================
# Need to confirm if this is correct practice to use global variables
#@export_enum(Globals.playerClass) var playerClass = Globals.playerClass
@export_range(0, 100) var playerHealth = Globals.playerHealth
@export var SPEED = Globals.playerSpeed
#===============================================================

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction: -1, 0 or 1
	var direction = Input.get_axis("move_left", "move_right")
	
	# Flip the sprite
	if direction > 0:
		animated_sprite.flip_h = false
	elif direction < 0:
		animated_sprite.flip_h = true
	
	# Play animation
	if is_on_floor():
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
	
func player():
	pass

func _on_slime_2_damage(damageAmount):
	print("Damagedonslime2damage")
	take_damage(damageAmount)

func take_damage(damageAmount):
	Globals.playerHealth -= damageAmount
	print(Globals.playerHealth)
	#TODO Play damaged animation
	#TODO Emit signal to update UI health

func _on_slime_damage(damageValue):
	print("Damagedonslimedamage")
	take_damage(damageValue)
