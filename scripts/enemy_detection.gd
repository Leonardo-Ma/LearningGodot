class_name EnemyDetection
extends Area2D

signal enemy_in_range

@onready var currentEnemy = null

func _init():
	collision_layer = 0
	collision_mask = 2 # Player mask

func _ready():
	connect("body_entered", self._on_body_entered)
	connect("body_exited", self._on_body_exited)
	set_process(true)
	
func _on_body_entered(body: CharacterBody2D):
	if owner.has_method("target_enemy"):
		currentEnemy = body
		emit_signal("enemy_in_range", body, true)

func _on_body_exited(body):
	if body == currentEnemy and owner.has_method("target_enemy"):
		currentEnemy = null
		emit_signal("enemy_in_range", body, false)

func _process(delta):
	if currentEnemy and owner.has_method("target_enemy"):
		owner.target_enemy(currentEnemy, true)
