extends Label

@onready var coin_amount_label = $"."

# TODO This is being executed each frame, make it a callable method only updated when coinsCollected is updated
func _process(_delta):
	coin_amount_label.text = str(Globals.coinsCollected, " / x")
	
