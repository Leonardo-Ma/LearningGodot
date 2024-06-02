extends Area2D

@onready var timer = $Timer

func _on_body_entered(_body):
	var player = get_tree().get_root().get_node("Game/Player")
	player.die()
