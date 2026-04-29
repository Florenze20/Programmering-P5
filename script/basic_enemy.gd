
#class for basic enemies.
#this is a template for the first enemy types
class_name EnemyBasic
extends Node2D
# variable for the health of the enemy
var enemyHP = 25
# variable for enemy tier. Higher tier means stronger enemy
# tier 0 is a straight forward melee enemy with a small health total.
var enemyTier = 0
# variable for the enemy's size. size 2 is the standard size
# size 1 is a small unit, with sizes 3 and 4 being bigger units.
# this may be a variable that is checked to determine footprint 
#rather than the size itsels
var enemyFootprint = 2



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
