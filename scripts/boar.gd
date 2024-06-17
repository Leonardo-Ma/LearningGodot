# https://www.youtube.com/watch?v=9u59U-DWNJs - How to Create an ENEMY In Godot 4
extends CharacterBody2D

const SPEED = 60
@onready var animatedSprite = $AnimatedSprite2D

func _ready():
	$EnemyDetection.connect("enemy_in_range", self._on_enemy_in_range)

func _on_enemy_in_range(enemy: CharacterBody2D, inInRange: bool):
	if inInRange:
		target_enemy(enemy, true)
	else:
		target_enemy(enemy, false)

## Every enemy on the game overrides this method to handle its behaviour
func target_enemy(enemy: CharacterBody2D, isInRange: bool):
	if isInRange:
		animatedSprite.play("move")
		var direction_x = sign(enemy.global_position.x - global_position.x)
		velocity = Vector2(direction_x * SPEED * get_process_delta_time(), 0) # Only move along x-axis
		
		animatedSprite.flip_h = (direction_x > 0) # Flip sprite based on movement direction
	else:
		animatedSprite.play("idle")
		# Slow down and eventually stop
		velocity = lerp(velocity, Vector2.ZERO, 0.07)
	move_and_collide(velocity)
