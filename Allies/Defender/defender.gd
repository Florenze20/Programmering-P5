extends BasicAlly

var attack_damage = 15
var attack_cooldown = 2.0
var can_attack = true
var is_dead = false

@onready var sprite = $CharacterBody2D/AnimatedSprite2D
@onready var attack_area = $AttackArea


func _ready():
	super._ready()
	AllyMaxHp = 25
	AllyHp = 25
	AllyCost = 100
	AllyBaseDamage = attack_damage
	var hit_delay = 0.4


func _process(delta):
	if is_dead:
		return
	
	if can_attack == false:
		return
	
	var enemy = find_enemy_in_attack_area()
	
	if enemy != null:
		attack(enemy)


func find_enemy_in_attack_area():
	for hit_body in attack_area.get_overlapping_bodies():
		if hit_body.is_in_group("enemies"):
			return hit_body
	
	return null


func attack(enemy):
	can_attack = false
	
	print("Defender attacker")
	
	sprite.play("attack_animation")
	
	if enemy.has_method("take_damage"):
		enemy.take_damage(attack_damage)
	else:
		print("Enemy mangler take_damage")
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true


func AllyDeath():
	if is_dead:
		return
	
	is_dead = true
	can_attack = false
	
	print("Defender døde")
	
	# Gør feltet ledigt igen, så man kan placere et nyt tower
	var tile_key = get_meta("tile_key", "")
	var map = get_tree().current_scene
	
	if tile_key != "" and map != null:
		map.occupied_tiles.erase(tile_key)
	
	# Slår collision fra, så enemies ikke bliver ved med at ramme den
	$CharacterBody2D/CollisionShape2D.disabled = true
	
	# Sørger for at death animation ikke looper
	if sprite.sprite_frames != null:
		sprite.sprite_frames.set_animation_loop("death_animation", false)
	
	# Spiller death animation én gang
	sprite.play("death_animation")
	
	# Venter til animationen er færdig
	await sprite.animation_finished
	
	# Fjerner defenderen
	queue_free()
