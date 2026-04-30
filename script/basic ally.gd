extends Node

class_name BasicAlly

# Ally Max hp and current hp respectively
var AllyMaxHp = 10
var AllyHp = 10
var AllyCost = 100
var AllyBaseDamage= 5

#Damage taking function, replace AllyBaseDamage with a enemy damage variable or constant
func AllyLifeLoss(AllyBaseDamage):
	AllyHp -= AllyBaseDamage
	if AllyHp < 1: 	
		AllyHp = 0
		AllyDeath()

func AllyDeath():
	remove_child(self)


	

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
