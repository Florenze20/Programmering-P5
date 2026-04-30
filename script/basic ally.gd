extends Node

class_name BasicAlly

# Ally Max hp and current hp respectively
var AllyMaxHp = 100
var AllyHp = 100
var AllyCost = 100
#AllyDR is the damage reduction, currently a flat amount.
var AllyDRFlat = 0
var AllyDRPercent = 0
var AllyBaseDamage= 50

#Damage taking function, replace AllyBaseDamage with a enemy damage variable or constant
func AllyLifeLoss(AllyBaseDamage):
	#Ally Damage reduction formula is as follows:
	#AllyBaseDamage-AllyDRFlat is the damage dealt, minus a flat damage amount.
	#1+AllyDRPercent/100 is 1 plus the ally damage reduction percent in percent
	AllyHp -= (AllyBaseDamage)/(1+AllyDRPercent/100)-AllyDRFlat
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
