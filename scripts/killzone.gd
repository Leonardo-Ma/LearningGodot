extends Area2D

func _on_body_entered(body):
	var player = get_tree().get_root().get_node("Game/Player")
	if (body == player):
		player.die()
