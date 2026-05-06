extends Node2D

class_name BasicAlly

# Maks HP og nuværende HP for ally
var AllyMaxHp = 100
var AllyHp = 100

# Hvor meget ally koster at placere
var AllyCost = 100

# Flat damage reduction
# Det betyder, at et fast tal bliver trukket fra skaden
var AllyDRFlat = 0

# Procent damage reduction
# Det betyder, at skaden bliver reduceret med en procent
var AllyDRPercent = 0

# Allyens grundskade når den angriber
var AllyBaseDamage = 25

# Hvilken lane ally står i, fx lane 0, 1, 2 osv.
var lane_index := 0

# Den præcise Y-position for den lane
var lane_y := 0


# Funktion til når ally tager skade
func AllyLifeLoss(Amount):
	# Først bliver skaden reduceret med procent
	# Derefter bliver flat damage reduction trukket fra
	AllyHp -= (Amount) / (1 + AllyDRPercent / 100) - AllyDRFlat
	
	# Hvis ally har 0 HP eller mindre, dør den
	if AllyHp <= 0:
		AllyDeath()


# Funktion til når ally dør
func AllyDeath():
	queue_free()


# Funktion til allyens angreb
# Den kan senere bruges til at skyde projektiler
func AllyShoot():
	pass


# Kaldes når noden kommer ind i scenen
func _ready() -> void:
	pass


# Kaldes hvert frame
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
