extends Node2D

@export var enemy_scene: PackedScene

var lanes = [100, 150, 200, 250, 300]

func _ready():
	print("MAP READY")
	spawn_enemy()

func spawn_enemy():
	print("SPAWNER ENEMY")

	if enemy_scene == null:
		print("ERROR: enemy_scene mangler")
		return

	var enemy = enemy_scene.instantiate()

	var lane = lanes.pick_random()

	enemy.lane_y = lane
	enemy.position = Vector2(600, lane)

	$Enemies.add_child(enemy)

	print("ENEMY ADDED")
