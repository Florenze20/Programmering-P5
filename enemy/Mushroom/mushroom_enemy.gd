extends EnemyBasic

# Bruges til at tjekke om mushroom allerede er i gang med at angribe
var is_attacking = false

# Finder AnimatedSprite2D, så vi kan skifte animationer
@onready var sprite = $AnimatedSprite2D


func _ready():
	super._ready()
	
	# Mushroom har mere liv, men er langsommere
	enemyHP = 60
	EnemySpeed = 10
	EnemyDamage = 2
	
	# Starter med running animation
	sprite.play("running_animation")


func attack(enemy):
	can_attack = false
	
	print("Defender attacker")
	
	# Sørger for attack animation ikke looper
	if sprite.sprite_frames != null:
		sprite.sprite_frames.set_animation_loop("attack_animation", false)
	
	# Spiller attack animation
	sprite.play("attack_animation")
	
	# Venter til det tidspunkt hvor slaget visuelt rammer
	await get_tree().create_timer(hit_delay).timeout
	
	# Giver først skade her
	if enemy != null and is_instance_valid(enemy):
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)
		else:
			print("Enemy mangler take_damage")
	
	# Venter resten af cooldown
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true
