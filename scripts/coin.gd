extends Area2D

@onready var animation_player = $AnimationPlayer

func _on_body_entered(body):
	Globals.add_coin()
	animation_player.play("pickup_animation")
	Globals.coinsCollected += 1
