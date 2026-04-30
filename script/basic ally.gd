extends Node

class_name BasicAlly

# Ally Max hp and current hp respectively
var AllyMaxHp = 20
var AllyHp = 20
var AllyCost = 100

func AllyLifeLoss(int):
	AllyHp -= int

# Called when the node enters the scene tree for the first time.

func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
