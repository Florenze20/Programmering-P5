extends Node2D

# lanes
var lanes = [170, 225, 280, 335, 390]
var spawn_x = 900

# Liste med de enemy scenes der kan spawne
var enemy_types = [
	preload("res://enemy/Bat/bat_enemy.tscn"),
	preload("res://enemy/Mushroom/mushroom_enemy.tscn")
]

func _ready():
	print("MAP READY")
	spawn_enemy()

# Her spawner en random enemy
func spawn_enemy():
	var enemy_scene = enemy_types.pick_random().instantiate()

	var lane_index = randi_range(0, lanes.size() - 1)
	var lane_y = lanes[lane_index]

	var enemy_body = enemy_scene.get_node("CharacterBody2D")

	enemy_body.lane_index = lane_index
	enemy_body.lane_y = lane_y

	# Root node skal KUN sætte X positionen
	# CharacterBody2D styrer selv Y-positionen gennem lane_y
	enemy_scene.position = Vector2(spawn_x, 0)

	$Enemies.add_child(enemy_scene)

	print("Enemy spawned in lane: ", lane_index)
