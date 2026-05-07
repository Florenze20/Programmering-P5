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
	AllyMaxHp = 35
	AllyHp = 35
	AllyCost = 50
	
	# Farmer står idle
	if sprite != null:
		sprite.play("idle_animation")
	
	# Starter penge produktionen
	start_farming()


func start_farming():
	while is_dead == false:
		# Venter før farmer giver penge
		await get_tree().create_timer(farm_cooldown).timeout
		
		if is_dead:
			return
		
		farm()


func farm():
	print("Farmer laver penge")
	
	# Finder map scenen
	var map = get_tree().current_scene
	
	# Tilføjer penge til map.gd
	if map != null:
		map.money += farm_amount
		map.update_money_text()
		print("Farmer gav penge: ", farm_amount)
	
	# Farmer bliver i idle animation
	if is_dead == false and sprite != null:
		sprite.play("idle_animation")


func AllyDeath():
	if is_dead:
		return
	
	is_dead = true
	
	print("Farmer døde")
	
	# Gør feltet ledigt igen
	var tile_key = get_meta("tile_key", "")
	var map = get_tree().current_scene
	
	if tile_key != "" and map != null:
		map.occupied_tiles.erase(tile_key)
	
	queue_free()
