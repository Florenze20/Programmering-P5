extends BasicAlly

# Stien som skal passe til scene
@onready var attack_area = get_node_or_null("CharacterBody2D/Sprite/Shoot_effect/AttackArea")
@onready var shoot_effect = get_node_or_null("CharacterBody2D/Sprite/Shoot_effect")

var attack_damage = 50
var attack_cooldown = 5.0
var can_attack = true
var is_dead = false


func _ready():
	super._ready()
	
	AllyDRFlat = 0
	AllyMaxHp = 25
	AllyHp = AllyMaxHp
	AllyCost = 100
	
	if shoot_effect != null:
		shoot_effect.visible = false
	
	if attack_area == null:
		print("Gunner AttackArea mangler")
	else:
		print("Gunner AttackArea fundet")


func _process(delta):
	if is_dead:
		return
	
	if can_attack == false:
		return
	
	var enemy = find_enemy_in_attack_area()
	
	if enemy != null:
		attack(enemy)


func find_enemy_in_attack_area():
	if attack_area == null:
		print("AttackArea er null")
		return null
	
	var bodies = attack_area.get_overlapping_bodies()
	
	if bodies.size() > 0:
		print("Gunner ser bodies: ", bodies.size())
	
	for hit_body in bodies:
		print("Gunner rammer body: ", hit_body.name)
		
		if hit_body.is_in_group("enemies"):
			print("Gunner fandt enemy")
			return hit_body
	
	return null


func attack(enemy):
	can_attack = false
	
	print("Gunner skyder")
	
	if shoot_effect != null:
		shoot_effect.visible = true
		shoot_effect.play("shoot_beam")
	
	if enemy != null and is_instance_valid(enemy):
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)
			print("Gunner gav damage: ", attack_damage)
		else:
			print("Enemy mangler take_damage")
	
	await get_tree().create_timer(0.5).timeout
	
	if shoot_effect != null:
		shoot_effect.visible = false
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true


func AllyDeath():
	if is_dead:
		return
	
	is_dead = true
	can_attack = false
	
	print("Gunner døde")
	
	var tile_key = get_meta("tile_key", "")
	var map = get_tree().current_scene
	
	if tile_key != "" and map != null:
		map.occupied_tiles.erase(tile_key)
	
	queue_free()
