extends Node2D

signal damage(damageValue)

const SPEED = 60

var _direction = 1

@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite_2d = $AnimatedSprite2D

func _process(delta):
	if ray_cast_right.is_colliding():
		_direction = -1
		animated_sprite_2d.flip_h = true
	elif ray_cast_left.is_colliding():
			_direction = 1
			animated_sprite_2d.flip_h = false
	position.x += _direction * SPEED * delta

#Just a reminder: For this to work collision mask needs to be 2 (Same as player layer) - 2 hours wasted...
func _on_damage_detection_body_entered(body):
	if body.has_method("player"):
		var damageAmount = 50
		emit_signal("damage", damageAmount)
		
func take_damage(damageAmount: int):
	animated_sprite_2d.play("default")
	print_debug("hit")
