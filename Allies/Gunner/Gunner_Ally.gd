extends BasicAlly

@onready var attack_area = $AttackArea
var attack_damage = 15
var attack_cooldown = 1.1
var hit_delay = 0.3
var can_attack = true
var is_dead = false

# Called when the node enters the scene tree for the first time.
func _ready():
	super._ready()
	var AllyDRFlat = 5
	var AllyMaxHp = 25
	var AllyHp = AllyMaxHp
	
	



# Called every frame. 'delta' is the elapsed time since the previous frame.
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
	
	# Spiller attack animation
	sprite.play("attack_animation")
	
	# Venter til slaget rammer
	await get_tree().create_timer(hit_delay).timeout
	
	# Giver damage
	if enemy != null and is_instance_valid(enemy):
		if enemy.has_method("take_damage"):
			enemy.take_damage(attack_damage)
		else:
			print("Enemy mangler take_damage")
	
	# Venter lidt så attack animationen kan nå at blive vist
	await get_tree().create_timer(0.4).timeout
	
	# Går tilbage til idle animation
	if is_dead == false:
		sprite.play("idle_animation")
	
	# Venter cooldown før næste attack
	await get_tree().create_timer(attack_cooldown).timeout
	
	can_attack = true

func AllyDeath():
	if is_dead:
		return
	
	is_dead = true
	can_attack = false
	
	print("Defender døde")
	
	var tile_key = get_meta("tile_key", "")
	var map = get_tree().current_scene
	
	if tile_key != "" and map != null:
		map.occupied_tiles.erase(tile_key)
	
	# Death spiller kun én gang
	sprite.play("death_animation")
	await sprite.animation_finished
	
	queue_free()
