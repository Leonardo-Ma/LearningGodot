extends Label

@onready var coin_amount_label = $"."

func _process(delta):
	coin_amount_label.text = str(Globals.coinsCollected, " / x")
	
