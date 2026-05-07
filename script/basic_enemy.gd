extends CharacterBody2D
class_name EnemyBasic

# Sender point til map.gd når enemy dør
signal died(points)

# Enemy stats
var enemyMaxHp = 25
var enemyHP = 25
var EnemySpeed = 50
var EnemyDamage = 25

# Hvor mange point enemy giver når den dør
var score_value = 10

# Stopper enemy fra at give point flere gange
var is_dead = false

var attack_cooldown = 1.0
var can_attack = true

var lane_index := 0
var lane_y := 0


func _ready():
	position.y = lane_y


func _physics_process(delta):
	if is_dead:
		return
	
	position.y = lane_y
	
	velocity = Vector2(-EnemySpeed, 0)
	move_and_slide()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var hit_body = collision.get_collider()
		var ally = get_ally_from_collision(hit_body)
		
		if ally != null and can_attack:
			attack_ally(ally)


func get_ally_from_collision(hit_body):
	if hit_body == null:
		return null
	
	if hit_body.has_method("AllyLifeLoss"):
		return hit_body
	
	if hit_body.get_parent() != null and hit_body.get_parent().has_method("AllyLifeLoss"):
		return hit_body.get_parent()
	
	return null


func attack_ally(ally):
	can_attack = false
	
	ally.AllyLifeLoss(EnemyDamage)
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true


func take_damage(amount):
	if is_dead:
		return
	
	enemyHP -= amount
	
	print("Enemy tog skade: ", amount)
	print("Enemy HP nu: ", enemyHP)
	
	if enemyHP <= 0:
		die()


func die():
	if is_dead:
		return
	
	is_dead = true
	
	print("Enemy døde og gav point: ", score_value)
	
	# Sender point til map.gd
	died.emit(score_value)
	
	# Fjerner hele enemy scenen
	var root = get_parent()
	
	if root != null and root.name != "Enemies":
		root.queue_free()
	else:
		queue_free()
