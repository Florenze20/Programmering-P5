extends Node2D

var lanes = []
var spawn_x = 1200

var enemy_types = [
	preload("res://enemy/Bat/bat_enemy.tscn"),
	preload("res://enemy/Mushroom/mushroom_enemy.tscn")
]

func _ready():
	print("MAP READY")
	
	print("Children of this node:")
	for child in get_children():
		print(child.name)

	var lane0 = get_node_or_null("LaneMarkers/Lane0")
	var lane1 = get_node_or_null("LaneMarkers/Lane1")
	var lane2 = get_node_or_null("LaneMarkers/Lane2")
	var lane3 = get_node_or_null("LaneMarkers/Lane3")
	var lane4 = get_node_or_null("LaneMarkers/Lane4")

	if lane0 == null:
		print("Lane0 mangler")
		return
	if lane1 == null:
		print("Lane1 mangler")
		return
	if lane2 == null:
		print("Lane2 mangler")
		return
	if lane3 == null:
		print("Lane3 mangler")
		return
	if lane4 == null:
		print("Lane4 mangler")
		return

	lanes = [
		lane0.global_position.y,
		lane1.global_position.y,
		lane2.global_position.y,
		lane3.global_position.y,
		lane4.global_position.y
	]

	print("Lanes loaded: ", lanes)

	spawn_enemy()


func spawn_enemy():
	print("SPAWN ENEMY START")

	if lanes.size() == 0:
		print("Ingen lanes fundet")
		return

	var enemy_scene = enemy_types.pick_random().instantiate()

	var lane_index = randi_range(0, lanes.size() - 1)
	var lane_y = lanes[lane_index]

	print("Lane valgt: ", lane_index, " y: ", lane_y)

	var enemy_body = enemy_scene.get_node_or_null("CharacterBody2D")

	if enemy_body == null:
		print("CharacterBody2D mangler i enemy scene")
		return

	enemy_body.lane_index = lane_index
	enemy_body.lane_y = lane_y

	enemy_scene.position = Vector2(spawn_x, 0)

	var enemies_node = get_node_or_null("Enemies")
	if enemies_node == null:
		print("Enemies node mangler")
		return

	enemies_node.add_child(enemy_scene)

	print("ENEMY ADDED")
