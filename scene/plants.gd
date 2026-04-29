extends Node2D

@export var damage := 5
@export var range := 300
@export var fire_rate := 1.0

var lane_y := 0
var can_shoot := true

func _ready():
	position.y = lane_y

func _process(delta):
	if can_shoot:
		var enemy = find_enemy()
		if enemy != null:
			shoot(enemy)

func find_enemy():
	for enemy in get_tree().get_nodes_in_group("enemies"):
		if enemy.lane_y == lane_y:
			if enemy.position.x > position.x:
				if position.distance_to(enemy.position) <= range:
					return enemy
	return null

func shoot(enemy):
	can_shoot = false
	enemy.take_damage(damage)

	await get_tree().create_timer(fire_rate).timeout
	can_shoot = true
