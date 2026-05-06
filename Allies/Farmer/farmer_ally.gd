extends BasicAlly

# Hvor mange penge farmer giver
var farm_amount = 50

# Hvor lang tid der går mellem hver gang farmer giver penge
var farm_cooldown = 24.0

# Bruges til at stoppe farmeren hvis den dør
var is_dead = false


func _ready():
	super._ready()
	
	# Farmer stats
	AllyMaxHp = 50
	AllyHp = 50
	AllyCost = 50
	
	# Farmer står idle
	if sprite != null:
		sprite.play("idle_animation")
	
	# Starter penge produktion
	start_farming()


func start_farming():
	while is_dead == false:
		await get_tree().create_timer(farm_cooldown).timeout
		
		if is_dead:
			return
		
		farm()


func farm():
	print("Farmer laver penge")
	
	var map = get_tree().current_scene
	
	if map != null:
		map.money += farm_amount
		map.update_money_text()
		print("Farmer gav penge: ", farm_amount)
	
	# Farmer bliver bare i idle når den laver penge
	if is_dead == false and sprite != null:
		sprite.play("idle_animation")


func AllyDeath():
	if is_dead:
		return
	
	is_dead = true
	
	print("Farmer døde")
	
	var tile_key = get_meta("tile_key", "")
	var map = get_tree().current_scene
	
	if tile_key != "" and map != null:
		map.occupied_tiles.erase(tile_key)
	
	queue_free()
