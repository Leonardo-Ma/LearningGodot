# https://www.youtube.com/watch?v=JWjzSn95bM0
class_name Hurtbox
extends Area2D

func _init():
	collision_layer = 0
	collision_mask = 4
	
func _ready():
	connect("area_entered", self._on_area_entered)
	
func _on_area_entered(hitbox: Hitbox):
	if (hitbox == null):
		return
		
	if (owner.has_method("take_damage")):
		owner.take_damage(hitbox.damage)
