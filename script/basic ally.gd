extends Node

class_name BasicAlly

# Ally Max hp and current hp respectively
var AllyMaxHp = 100
var AllyHp = 100
var AllyCost = 100
#AllyDRFlat is the flat amount an amount of damage is reduced by, happens after the percent.
var AllyDRFlat = 0
#AllyDRPercent is the percentage amount an amount of damage is reduced by, happens before the flat reduction.
var AllyDRPercent = 0
#The base damage an ally unit does with its attacks.
var AllyBaseDamage= 25

# Hvilken lane enemy er i fx lane 0, 1, 2 osv.
var lane_index := 0

# Den præcise Y-position for den lane
var lane_y := 0


#Damage taking function, replace AllyBaseDamage with a enemy damage variable or constant
func AllyLifeLoss(Amount):
	#Ally Damage reduction formula is as follows:
	#AllyBaseDamage-AllyDRFlat is the damage dealt, minus a flat damage amount.
	#1+AllyDRPercent/100 is 1 plus the ally damage reduction percent in percent
	AllyHp -= (Amount)/(1+AllyDRPercent/100)-AllyDRFlat
	if AllyHp <= 0: 	
		AllyDeath()

#The ally dies.
func AllyDeath():
	queue_free

#Implement a shooting function, needs to fire a moving projectile
#Needs to be able to hit enemies and deal damage.
func AllyShoot():
	pass


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
