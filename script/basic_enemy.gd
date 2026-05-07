extends CharacterBody2D

class_name EnemyBasic

# Signal bliver sendt når enemy dør
signal died(points)

#
# Hvor meget liv enemy har
var enemyHP = 25

# Hvor meget score man får når enemy dør
var score_value = 10

# Hvor stærk enemy er
var enemyTier = 0

# Hvor stor enemy er
var enemyFootprint = 2

# Hvor hurtigt enemy går
var EnemySpeed = 50

# Hvor meget skade enemy laver på towers
var EnemyDamage = 25

# Hvor lang tid der går mellem hvert attack
var attack_cooldown = 1.0

# Gør så enemy ikke angriber hvert frame
var can_attack = true

# Hvilken lane enemy er i
var lane_index := 0

# Den præcise Y-position for lane
var lane_y := 0


func _ready():
	# Når enemy spawner, bliver den sat på sin lane
	position.y = lane_y


func _physics_process(delta):
	# Holder enemy fast i sin lane
	position.y = lane_y
	
	# Enemy går mod venstre
	velocity = Vector2(-EnemySpeed, 0)
	move_and_slide()
	
	# Tjekker om enemy rammer et tower
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var hit_body = collision.get_collider()
		
		var ally = get_ally_from_collision(hit_body)
		
		if ally != null and can_attack:
			attack_ally(ally)


func get_ally_from_collision(hit_body):
	# Hvis der ikke er noget hit, stopper vi
	if hit_body == null:
		return null
	
	# Hvis selve objektet har AllyLifeLoss, er det et tower
	if hit_body.has_method("AllyLifeLoss"):
		return hit_body
	
	# Hvis scriptet sidder på parent/root, tjekker vi parent
	if hit_body.get_parent() != null and hit_body.get_parent().has_method("AllyLifeLoss"):
		return hit_body.get_parent()
	
	return null


func attack_ally(ally):
	# Enemy må ikke angribe igen før cooldown er færdig
	can_attack = false
	
	print("Enemy attacker ally")
	
	# Tower mister liv
	ally.AllyLifeLoss(EnemyDamage)
	
	# Venter før enemy kan angribe igen
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true


func take_damage(amount):
	# Enemy mister HP
	enemyHP -= amount
	
	print("Enemy tog skade: ", amount)
	print("Enemy HP nu: ", enemyHP)
	
	# Hvis enemy ikke har mere liv, dør den
	if enemyHP <= 0:
		die()


func die():
	print("Enemy døde")
	
<<<<<<< HEAD
	# Tilføjer score til map.gd
	#if map != null:
	#	map.score += enemyHP
	#	map.update_score_text()
	
=======
	# Sender score til map.gd
	died.emit(score_value)
	
	# Fjerner hele enemy scenen
>>>>>>> bd72a2222157423d11026dec4f87c02760ccb752
	var root = get_parent()
	
	if root != null and root.name != "Enemies":
		root.queue_free()
	else:
		queue_free()
