extends EnemyBasic

# Tjekker om mushroom allerede angriber
var is_attacking = false

# Tjekker om mushroom allerede spiller hit animation
var is_hurt = false

# Finder AnimatedSprite2D
@onready var sprite = $AnimatedSprite2D


func _ready():
	super._ready()
	
	# Mushroom stats
	enemyHP = 60
	EnemySpeed = 10
	EnemyDamage = 4
	
	# Mushroom går normalt med running animation
	if sprite != null:
		sprite.play("running_animation")


# Denne funktion kører når mushroom angriber et tower
func attack_ally(ally):
	if is_attacking:
		return
	
	is_attacking = true
	can_attack = false
	
	print("Mushroom angriber tower")
	
	# VIGTIGT:
	# Mushroom spiller IKKE hit_animation her
	# Fordi hit_animation betyder at mushroom selv tager skade
	
	# Venter 1 sekund før mushroom laver damage
	await get_tree().create_timer(1.0).timeout
	
	# Hvis tower stadig findes, tager det skade
	if ally != null and is_instance_valid(ally):
		ally.AllyLifeLoss(EnemyDamage)
		print("Mushroom lavede damage på tower")
	
	# Venter cooldown før mushroom kan angribe igen
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true
	is_attacking = false
	
	# Går tilbage til running animation
	if sprite != null and is_hurt == false:
		sprite.play("running_animation")


# Denne funktion kører når mushroom selv tager skade
func take_damage(amount):
	enemyHP -= amount
	
	print("Mushroom tog skade: ", amount)
	print("Mushroom HP: ", enemyHP)
	
	if enemyHP <= 0:
		die()
		return
	
	play_hit_animation()


# Mushroom spiller kun hit_animation når den selv tager skade
func play_hit_animation():
	if is_hurt:
		return
	
	if sprite == null:
		return
	
	is_hurt = true
	
	sprite.play("hit_animation")
	
	await sprite.animation_finished
	
	is_hurt = false
	
	if is_attacking == false:
		sprite.play("running_animation")
