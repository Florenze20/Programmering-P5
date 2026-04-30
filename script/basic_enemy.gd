extends CharacterBody2D
class_name EnemyBasic

# Enemyhp er hvor meget liv de har dvs basic enemy har 25 HP
var enemyHP = 25

# Hvor stærk modstanderen er hvor 0 er basic/svageste
var enemyTier = 0

# Hvor stor modstanderen er
var enemyFootprint = 2

# Enemy movement speed
var EnemySpeed = 50

# Hvilken lane enemy er i fx lane 0, 1, 2 osv.
var lane_index := 0

# Den præcise Y-position for den lane
var lane_y := 0


func _ready():
	# Når enemy spawner, sættes den til sin lane
	position.y = lane_y


func _physics_process(delta):
	# Låser enemy fast i sin lane
	position.y = lane_y
	
	# Bevæger enemy mod venstre
	velocity = Vector2(-EnemySpeed, 0)
	
	# Flytter enemy med physics/collision
	move_and_slide()


func take_damage(amount):
	enemyHP -= amount
	
	if enemyHP <= 0:
		queue_free()
