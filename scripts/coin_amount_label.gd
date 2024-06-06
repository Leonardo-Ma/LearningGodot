extends Label

# TODO This is being executed each frame, should be called from signal
func _process(_delta):
	self.text = str(Globals.coins, " / x")
