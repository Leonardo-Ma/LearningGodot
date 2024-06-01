extends Node

enum playerClass {NoClass, Wizard, Knight}

var coinsCollected = 0
var playerHealth = 100
var playerDamage = 10
var playerSpeed = 130.0
var coins = 0

func _ready():
	randomize()
	soundtrack_player.play_theme(soundtrackPlayerClass.PlaylistTheme.PEACE)
	
func add_coin():
	coins += 1
