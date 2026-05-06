extends Node2D

class_name BasicAlly

# Finder AnimatedSprite2D på allyen
# Den bruges til at skifte mellem idle_animation og hit_animation
@onready var sprite = get_node_or_null("CharacterBody2D/AnimatedSprite2D")

# Bruges til at tjekke om ally allerede er i gang med hit animation
var is_hurt = false

# Maks HP og nuværende HP for ally
var AllyMaxHp = 100
var AllyHp = 100

# Hvor meget ally koster at placere
var AllyCost = 100

# Flat damage reduction
# Et fast tal der bliver trukket fra skaden
var AllyDRFlat = 0

# Procent damage reduction
# Reducerer skaden med en procent
var AllyDRPercent = 0

# Allyens grundskade når den angriber
var AllyBaseDamage = 25

# Hvilken lane ally står i, fx lane 0, 1, 2 osv.
var lane_index := 0

# Den præcise Y-position for den lane
var lane_y := 0


# Funktion der bliver kaldt når ally tager skade
func AllyLifeLoss(Amount):
	# Udregner hvor meget skade ally faktisk tager
	var damage_taken = (Amount) / (1 + AllyDRPercent / 100) - AllyDRFlat
	
	# Sørger for at skaden ikke kan blive negativ
	if damage_taken < 0:
		damage_taken = 0
	
	# Trækker skaden fra allyens HP
	AllyHp -= damage_taken
	
	print("Ally tog skade: ", damage_taken)
	print("Ally HP: ", AllyHp)
	
	# Hvis ally stadig lever, spiller den hit animation
	if AllyHp > 0:
		play_hit_animation()
	
	# Hvis ally har 0 HP eller mindre, dør den
	if AllyHp <= 0:
		AllyDeath()


# Funktion der spiller hit animation når ally tager skade
func play_hit_animation():
	# Stopper hvis ally allerede spiller hit animation
	if is_hurt:
		return
	
	# Stopper hvis der ikke findes en sprite
	if sprite == null:
		return
	
	# Sætter ally til at være i hurt-state
	is_hurt = true
	
	# Sørger for at hit_animation ikke looper
	if sprite.sprite_frames != null:
		sprite.sprite_frames.set_animation_loop("hit_animation", false)
	
	# Spiller hit animationen
	sprite.play("hit_animation")
	
	# Venter til hit animationen er færdig
	await sprite.animation_finished
	
	# Går tilbage til idle animation bagefter
	if is_hurt and sprite != null:
		sprite.play("idle_animation")
	
	# Ally er ikke længere i hurt-state
	is_hurt = false


# Funktion til når ally dør
func AllyDeath():
	queue_free()


# Funktion til allyens angreb
# Kan senere bruges til projektiler eller andre angreb
func AllyShoot():
	pass


# Kaldes når noden kommer ind i scenen
func _ready() -> void:
	pass


# Kaldes hvert frame
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass
