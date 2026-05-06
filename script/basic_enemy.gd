extends CharacterBody2D
class_name EnemyBasic

# Enemyhp er hvor meget liv de har
var enemyMaxHp = 25
var enemyHP = enemyMaxHp

# Hvor stærk modstanderen er
var enemyTier = 0

# Hvor stor modstanderen er
var enemyFootprint = 2

# Enemy movement speed
var EnemySpeed = 50

# Hvor meget skade enemy gør på allies
var EnemyDamage = 25

# Hvor lang tid der går mellem hvert angreb
var attack_cooldown = 1.0

# Bruges så enemy ikke angriber hvert eneste frame
var can_attack = true

# Hvilken lane enemy er i
var lane_index := 0

# Den præcise Y-position for den lane
var lane_y := 0


func _ready():
	position.y = lane_y


func _physics_process(delta):
	# Holder enemy fast i sin lane
	position.y = lane_y
	
	# Bevæger enemy mod venstre
	velocity = Vector2(-EnemySpeed, 0)
	move_and_slide()
	
	# Tjekker om enemy rammer en ally/tower
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var hit_body = collision.get_collider()
		
		var ally = get_ally_from_collision(hit_body)
		
		if ally != null and can_attack:
			attack_ally(ally)


func get_ally_from_collision(hit_body):
	if hit_body == null:
		return null
	
	# Hvis selve body har AllyLifeLoss
	if hit_body.has_method("AllyLifeLoss"):
		return hit_body
	
	# Hvis scriptet sidder på root noden, fx Defender
	if hit_body.get_parent() != null and hit_body.get_parent().has_method("AllyLifeLoss"):
		return hit_body.get_parent()
	
	return null


func attack_ally(ally):
	can_attack = false
	
	print("Enemy attacker ally")
	
	ally.AllyLifeLoss(EnemyDamage)
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true


func take_damage(amount):
	enemyHP -= amount
	
	print("Enemy tog skade: ", amount)
	print("Enemy HP nu: ", enemyHP)
	
	if enemyHP <= 0:
		die()


func die():
	print("Enemy døde")
	var map = get_tree().current_scene
	
	# Tilføjer score til map.gd
	if map != null:
		map.score += enemyHP
		map.update_score_text()
	var root = get_parent()
	
	if root != null and root.name != "Enemies":
		root.queue_free()
	else:
		queue_free()
