
#class for basic enemies.
#this is a template for the first enemy types
extends CharacterBody3D
class_name EnemyBasic

# variable for the health of the enemy
var enemyHP = 25
var enemyTier = 0
var enemyFootprint = 2

@export var speed := 2.0
@export var lane_x := 2.0

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn_enemy()

func spawn_enemy():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position.x = lane_x
	velocity = Vector3(0, 0, -speed)
	move_and_slide()
	
