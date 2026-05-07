extends Node2D

# Tower scenes sættes i Inspector
@export var farmer_scene: PackedScene
@export var defender_scene: PackedScene
@export var gunner_scene: PackedScene


# Pris på towers
@export var farmer_cost: int = 50
@export var defender_cost: int = 100
@export var gunner_cost: int = 300


# Hvor mange liv spilleren starter med
var lives = 3

# Spillerens score
var score: int = 0

# Når en enemy kommer længere til venstre end denne X-position, mister spilleren 1 liv
var lose_x = 150

# Bruges til at stoppe spillet, når spilleren har tabt
var game_over = false

# Labels til liv, score og game over
var lives_label = null
var score_label = null
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
	var gunner_button = get_node_or_null("BoxInterface/GunnerButton")
	
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
	
	# Connecter gunner-knappen
	if gunner_button != null:
		gunner_button.pressed.connect(_on_gunner_button_pressed)
	else:
		print("GunnerButton mangler")
	
	# Finder labels
	wave_label = get_node_or_null("WaveLabel")
	wave_timer_label = get_node_or_null("WaveTimerLabel")
	money_label = get_node_or_null("BoxInterface/MoneyLabel")
	
	# Finder LivesLabel direkte under Map
	lives_label = get_node_or_null("LivesLabel")
	
	# Hvis den ikke ligger direkte under Map, prøver den inde i BoxInterface
	if lives_label == null:
		lives_label = get_node_or_null("BoxInterface/LivesLabel")
	
	# Finder ScoreLabel direkte under Map
	score_label = get_node_or_null("ScoreLabel")
	
	# Hvis den ikke ligger direkte under Map, prøver den inde i BoxInterface
	if score_label == null:
		score_label = get_node_or_null("BoxInterface/ScoreLabel")
	
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
	
	if score_label == null:
		print("ScoreLabel mangler")
	
	if game_over_label == null:
		print("GameOverLabel mangler")
	else:
		game_over_label.visible = false
	
	# Viser penge, liv og score fra start
	update_money_text()
	update_lives_text()
	update_score_text()
	
	# Finder lane markers
	var lane0 = get_node_or_null("LaneMarkers/Lane0")
	var lane1 = get_node_or_null("LaneMarkers/Lane1")
	var lane2 = get_node_or_null("LaneMarkers/Lane2")
	var lane3 = get_node_or_null("LaneMarkers/Lane3")
	var lane4 = get_node_or_null("LaneMarkers/Lane4")
	
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
	if game_over:
		return
	
	check_enemies_reached_end()


func update_money_text():
	if money_label != null:
		money_label.text = "Money: " + str(money)


func update_lives_text():
	if lives_label != null:
		lives_label.text = "Lives: " + str(lives)


func update_score_text():
	if score_label != null:
		score_label.text = "Score: " + str(score)


func add_score(amount: int):
	score += amount
	update_score_text()
	print("Score: ", score)


func _on_enemy_died(points: int):
	add_score(points)


func update_wave_text():
	if wave_label != null:
		wave_label.text = "Wave: " + str(wave_number)


func update_timer_text(seconds_left):
	if wave_timer_label != null:
		wave_timer_label.text = "Next wave in: " + str(seconds_left)


func start_waves():
	while game_over == false:
		update_wave_text()
		
		if wave_timer_label != null:
			wave_timer_label.text = "Wave in progress"
		
		print("Wave ", wave_number, " starter")
		
		for i in range(enemies_per_wave):
			if game_over:
				return
			
			spawn_enemy()
			await get_tree().create_timer(spawn_delay).timeout
		
		print("Wave ", wave_number, " færdig")
		
		wave_number += 1
		enemies_per_wave += enemies_added_each_wave
		
		for seconds_left in range(time_between_waves, 0, -1):
			if game_over:
				return
			
			update_timer_text(seconds_left)
			await get_tree().create_timer(1.0).timeout


func spawn_enemy():
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
	
	enemy_body.lane_index = lane_index
	enemy_body.lane_y = lane_y
	enemy_body.add_to_group("enemies")
	
	# Når enemy dør, giver den score
	if enemy_body.has_signal("died"):
		enemy_body.died.connect(_on_enemy_died)
	else:
		print("Enemy mangler died signal")
	
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
	
	for enemy_scene in enemies_node.get_children():
		var enemy_body = enemy_scene.get_node_or_null("CharacterBody2D")
		
		if enemy_body == null:
			continue
		
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
	
	if game_over_label != null:
		game_over_label.visible = true
		game_over_label.text = "GAME OVER"
	
	if wave_timer_label != null:
		wave_timer_label.text = "Game Over"
	
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


func _on_gunner_button_pressed():
	if game_over:
		return
	
	if gunner_scene == null:
		print("Gunner scene er ikke sat i Inspector")
		return
	
	selected_tower_scene = gunner_scene
	selected_tower_cost = gunner_cost
	
	print("Gunner valgt")
	print("Gunner cost: ", selected_tower_cost)


func _unhandled_input(event):
	if game_over:
		return
	
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		
		if selected_tower_scene == null:
			return
		
		var mouse_pos = get_global_mouse_position()
		place_tower(mouse_pos)


func place_tower(mouse_pos):
	var lane_index = get_closest_lane_index(mouse_pos.y)
	var lane_y = lanes[lane_index]
	
	var column_index = get_closest_column_index(mouse_pos.x)
	var column_x = grid_start_x + column_index * cell_width
	
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
	
	money -= selected_tower_cost
	update_money_text()
	
	var tower = selected_tower_scene.instantiate()
	
	tower.set_meta("lane_index", lane_index)
	tower.set_meta("lane_y", lane_y)
	tower.set_meta("tile_key", tile_key)
	
	tower.position = Vector2(column_x, lane_y)
	
	var allies_node = get_node_or_null("Allies")
	if allies_node == null:
		print("Allies node mangler")
		return
	
	allies_node.add_child(tower)
	
	occupied_tiles[tile_key] = tower
	
	print("Tower placeret på felt: ", tile_key)
	print("Money tilbage: ", money)
	
	selected_tower_scene = null
	selected_tower_cost = 0


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
