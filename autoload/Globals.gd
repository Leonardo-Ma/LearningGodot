extends Node

enum playerClass {NoClass, Wizard, Knight}

var playerHealth: int = 100
var playerDamage: int = 10
var playerSpeed: float = 130.0
var coins: int = 0

func _ready():
	randomize()
	soundtrack_player.play_theme(soundtrackPlayerClass.PlaylistTheme.PEACE)
	
func add_coin():
	coins += 1
	
func resetValues():
	Globals.playerHealth = 100
	Globals.coins = 0
