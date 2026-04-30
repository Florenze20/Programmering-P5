extends Node2D

var lanes = [170, 225, 280, 335, 390]
var spawn_x = 900

func _ready():
	print("MAP READY")
	spawn_enemy()


func spawn_enemy():
	var bat_scene = preload("res://enemy/Bat/bat_enemy.tscn").instantiate()

	var lane_index = randi_range(0, lanes.size() - 1)
	var lane_y = lanes[lane_index]

	var enemy_body = bat_scene.get_node("CharacterBody2D")

	enemy_body.lane_index = lane_index
	enemy_body.lane_y = lane_y

	bat_scene.position = Vector2(spawn_x, lane_y)
	$Enemies.add_child(bat_scene)

	print("Bat spawned in lane: ", lane_index)
