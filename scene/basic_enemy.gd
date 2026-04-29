extends CharacterBody3D
#class_name EnemyBasic

# Stats
var enemyHP = 25
var enemyTier = 0
var enemyFootprint = 2


@export var speed := 2.0
var lane_x := 0.0

func _ready():
	position.x = lane_x

func _physics_process(delta):
	position.x = lane_x
	velocity = Vector3(0, 0, -speed)
	move_and_slide()
