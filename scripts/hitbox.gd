# https://www.youtube.com/watch?v=JWjzSn95bM0
class_name Hitbox
extends Area2D

@export var damage := 10

func _init():
	collision_layer = 4
	collision_mask = 0
