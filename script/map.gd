extends Node2D

# Tower scenes sættes i Inspector
@export var farmer_scene: PackedScene
@export var defender_scene: PackedScene
@export var gunner_scene: PackedScene


# Pris på towers
@export var farmer_cost: int = 50
@export var defender_cost: int = 100
@export var gunner_cost: int = 100


# Hvor mange liv spilleren starter med
var lives = 3

# Når en enemy kommer længere til venstre end denne X-position, mister spilleren 1 liv
var lose_x = 150

# Bruges til at stoppe spillet, når spilleren har tabt
var game_over = false

# Labels til liv og game over
var lives_label = null
var game_over_label = null

# Det tower spilleren har valgt
var selected_tower_scene: PackedScene = null

# Prisen på det valgte tower
var selected_tower_cost: int = 0

# Spillerens penge
var money: int = 9999

# Liste der bliver fyldt med y-positionerne fra LaneMarkers
var lanes = []

# X positionen for den første firkant på banen
var grid_start_x = 310

# Afstand mellem hver firkant
var cell_width = 80

# Antal kolonner på banen
var column_count = 10

# Holder styr på hvilke felter der allerede har et tower
var occupied_tiles = {}

# Hvor langt ude til højre enemies spawner
var spawn_x = 1200

# Hvilken wave man er på
var wave_number = 1

# Hvor mange enemies der spawner i første wave
var enemies_per_wave = 10

# Hvor mange ekstra enemies der kommer per wave
var enemies_added_each_wave = 2

# Tid mellem hver enemy i samme wave
var spawn_delay = 1.0

# Pause mellem waves
var time_between_waves = 10

# UI labels
var wave_label = null
var wave_timer_label = null
var money_label = null

# Enemy typer der kan spawne
var enemy_types = [
	preload("res://enemy/Bat/bat_enemy.tscn"),
	preload("res://enemy/Mushroom/mushroom_enemy.tscn")
]


func _ready():
	print("MAP READY")
	
	# Finder knapperne i interfacet
	var farmer_button = get_node_or_null("BoxInterface/FarmerButton")
	var defender_button = get_node_or_null("BoxInterface/DefenderButton")
	
	# Connecter farmer-knappen
	if farmer_button != null:
		farmer_button.pressed.connect(_on_farmer_button_pressed)
	else:
		print("FarmerButton mangler")
	
	# Connecter defender-knappen
	if defender_button != null:
		defender_button.pressed.connect(_on_defender_button_pressed)
	else:
		print("DefenderButton mangler")
	
	# Finder labels
	wave_label = get_node_or_null("WaveLabel")
	wave_timer_label = get_node_or_null("WaveTimerLabel")
	money_label = get_node_or_null("BoxInterface/MoneyLabel")
	
	# Finder LivesLabel direkte under Map
	lives_label = get_node_or_null("LivesLabel")
	
	# Hvis den ikke ligger direkte under Map, prøver den inde i BoxInterface
	if lives_label == null:
		lives_label = get_node_or_null("BoxInterface/LivesLabel")
	
	# Finder GameOverLabel direkte under Map
	game_over_label = get_node_or_null("GameOverLabel")
	
	# Hvis den ikke ligger direkte under Map, prøver den inde i BoxInterface
	if game_over_label == null:
		game_over_label = get_node_or_null("BoxInterface/GameOverLabel")
	
	if wave_label == null:
		print("WaveLabel mangler")
	
	if wave_timer_label == null:
		print("WaveTimerLabel mangler")
	
	if money_label == null:
		print("MoneyLabel mangler")
	
	if lives_label == null:
		print("LivesLabel mangler")
	
	if game_over_label == null:
		print("GameOverLabel mangler")
	else:
		# Game over teksten skal være skjult fra start
		game_over_label.visible = false
	
	# Viser penge og liv fra start
	update_money_text()
	update_lives_text()
	
	# Finder lane markers
	var lane0 = get_node_or_null("LaneMarkers/Lane0")
	var lane1 = get_node_or_null("LaneMarkers/Lane1")
	var lane2 = get_node_or_null("LaneMarkers/Lane2")
	var lane3 = get_node_or_null("LaneMarkers/Lane3")
	var lane4 = get_node_or_null("LaneMarkers/Lane4")
	
	# Stopper hvis en lane mangler
	if lane0 == null or lane1 == null or lane2 == null or lane3 == null or lane4 == null:
		print("En eller flere lane markers mangler")
		return
	
	# Gemmer lane y-positioner
	lanes = [
		lane0.global_position.y,
		lane1.global_position.y,
		lane2.global_position.y,
		lane3.global_position.y,
		lane4.global_position.y
	]
	
	print("Lanes loaded: ", lanes)
	
	# Starter waves
	start_waves()


func _process(delta):
	# Stopper tjekket hvis spillet er tabt
	if game_over:
		return
	
	# Tjekker om enemies er kommet igennem
	check_enemies_reached_end()


func update_money_text():
	if money_label != null:
		money_label.text = "Money: " + str(money)


func update_lives_text():
	if lives_label != null:
		lives_label.text = "Lives: " + str(lives)


func update_wave_text():
	if wave_label != null:
		wave_label.text = "Wave: " + str(wave_number)


func update_timer_text(seconds_left):
	if wave_timer_label != null:
		wave_timer_label.text = "Next wave in: " + str(seconds_left)


func start_waves():
	# Kører waves indtil game over
	while game_over == false:
		update_wave_text()
		
		if wave_timer_label != null:
			wave_timer_label.text = "Wave in progress"
		
		print("Wave ", wave_number, " starter")
		
		# Spawner enemies i denne wave
		for i in range(enemies_per_wave):
			if game_over:
				return
			
			spawn_enemy()
			await get_tree().create_timer(spawn_delay).timeout
		
		print("Wave ", wave_number, " færdig")
		
		# Gør næste wave sværere
		wave_number += 1
		enemies_per_wave += enemies_added_each_wave
		
		# Countdown før næste wave
		for seconds_left in range(time_between_waves, 0, -1):
			if game_over:
				return
			
			update_timer_text(seconds_left)
			await get_tree().create_timer(1.0).timeout


func spawn_enemy():
	# Stopper hvis spillet er tabt
	if game_over:
		return
	
	print("SPAWN ENEMY START")
	
	if lanes.size() == 0:
		print("Ingen lanes fundet")
		return
	
	var enemy_scene = enemy_types.pick_random().instantiate()
	
	var lane_index = randi_range(0, lanes.size() - 1)
	var lane_y = lanes[lane_index]
	
	var enemy_body = enemy_scene.get_node_or_null("CharacterBody2D")
	
	if enemy_body == null:
		print("CharacterBody2D mangler i enemy scene")
		return
	
	# Giver enemy lane info
	enemy_body.lane_index = lane_index
	enemy_body.lane_y = lane_y
	
	# Gør så defender kan finde enemies
	enemy_body.add_to_group("enemies")
	
	# Root node styrer kun x positionen
	enemy_scene.position = Vector2(spawn_x, 0)
	
	var enemies_node = get_node_or_null("Enemies")
	if enemies_node == null:
		print("Enemies node mangler")
		return
	
	enemies_node.add_child(enemy_scene)
	
	print("ENEMY ADDED")


func check_enemies_reached_end():
	var enemies_node = get_node_or_null("Enemies")
	
	if enemies_node == null:
		return
	
	# Går igennem alle enemies på banen
	for enemy_scene in enemies_node.get_children():
		var enemy_body = enemy_scene.get_node_or_null("CharacterBody2D")
		
		if enemy_body == null:
			continue
		
		# Hvis enemy er kommet for langt til venstre, mister spilleren 1 liv
		if enemy_body.global_position.x <= lose_x:
			enemy_scene.queue_free()
			lose_life()


func lose_life():
	lives -= 1
	update_lives_text()
	
	print("Mistede 1 liv. Liv tilbage: ", lives)
	
	if lives <= 0:
		game_over_screen()


func game_over_screen():
	game_over = true
	
	print("GAME OVER")
	
	# Viser game over tekst
	if game_over_label != null:
		game_over_label.visible = true
		game_over_label.text = "GAME OVER"
	
	# Stopper timer-teksten
	if wave_timer_label != null:
		wave_timer_label.text = "Game Over"
	
	# Fjerner alle enemies, så de ikke fortsætter efter game over
	var enemies_node = get_node_or_null("Enemies")
	
	if enemies_node != null:
		for enemy in enemies_node.get_children():
			enemy.queue_free()


func _on_farmer_button_pressed():
	if game_over:
		return
	
	if farmer_scene == null:
		print("Farmer scene er ikke sat i Inspector")
		return
	
	selected_tower_scene = farmer_scene
	selected_tower_cost = farmer_cost
	
	print("Farmer valgt")
	print("Farmer cost: ", selected_tower_cost)


func _on_defender_button_pressed():
	if game_over:
		return
	
	if defender_scene == null:
		print("Defender scene er ikke sat i Inspector")
		return
	
	selected_tower_scene = defender_scene
	selected_tower_cost = defender_cost
	
	print("Defender valgt")
	print("Defender cost: ", selected_tower_cost)


func _unhandled_input(event):
	# Man kan ikke placere towers efter game over
	if game_over:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		if selected_tower_scene == null:
			return
		
		var mouse_pos = get_global_mouse_position()
		place_tower(mouse_pos)


func place_tower(mouse_pos):
	# Finder nærmeste lane
	var lane_index = get_closest_lane_index(mouse_pos.y)
	var lane_y = lanes[lane_index]
	
	# Finder nærmeste firkant/kolonne
	var column_index = get_closest_column_index(mouse_pos.x)
	var column_x = grid_start_x + column_index * cell_width
	
	# Key bruges til at se om feltet allerede er brugt
	var tile_key = str(lane_index) + "_" + str(column_index)
	
	if occupied_tiles.has(tile_key):
		print("Der står allerede et tower her")
		return
	
	print("Money: ", money)
	print("Selected tower cost: ", selected_tower_cost)
	
	if selected_tower_cost <= 0:
		print("Tower cost er ikke sat")
		return
	
	if money < selected_tower_cost:
		print("Ikke nok penge")
		return
	
	# Trækker penge fra
	money -= selected_tower_cost
	update_money_text()
	
	# Spawner det valgte tower
	var tower = selected_tower_scene.instantiate()
	
	# Gemmer hvilken lane og hvilket felt tower står i
	tower.set_meta("lane_index", lane_index)
	tower.set_meta("lane_y", lane_y)
	tower.set_meta("tile_key", tile_key)
	
	# Placerer toweret midt på feltet
	tower.position = Vector2(column_x, lane_y)
	
	var allies_node = get_node_or_null("Allies")
	if allies_node == null:
		print("Allies node mangler")
		return
	
	allies_node.add_child(tower)
	
	# Gemmer at feltet er brugt
	occupied_tiles[tile_key] = tower
	
	print("Tower placeret på felt: ", tile_key)
	print("Money tilbage: ", money)
	
	# Nulstiller valgt tower
	selected_tower_scene = null
	selected_tower_cost = 0
#test

func get_closest_lane_index(mouse_y):
	var closest_index = 0
	
	for i in range(lanes.size()):
		if abs(mouse_y - lanes[i]) < abs(mouse_y - lanes[closest_index]):
			closest_index = i
	
	return closest_index


func get_closest_column_index(mouse_x):
	var column_index = int(round((mouse_x - grid_start_x) / cell_width))
	column_index = clamp(column_index, 0, column_count - 1)
	return column_index
