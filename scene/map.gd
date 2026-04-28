extends Node3D

@export var enemy_scene: PackedScene

var lanes = [-4, -2, 0, 2, 4]

func _ready():
	print("MAP READY")
	spawn_enemy()

func spawn_enemy():
	print("SPAWNER ENEMY")

	if enemy_scene == null:
		print("ERROR: enemy_scene er tom")
		return

	var enemy = enemy_scene.instantiate() as EnemyBasic

	if enemy == null:
		print("ERROR: enemy er ikke EnemyBasic")
		return

	var lane = lanes.pick_random()

	enemy.lane_x = lane
	enemy.position = Vector3(lane, 2, 0)

	add_child(enemy)

	print("ENEMY ADDED")
