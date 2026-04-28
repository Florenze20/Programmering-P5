extends CharacterBody3D
#class_name EnemyBasic

# Stats
var enemyHP = 25
var enemyTier = 0
var enemyFootprint = 2

# Movement
@export var speed := 2.0
var lane_x := 0.0

func _ready() -> void:
	# Sæt enemy i sin lane
	position.x = lane_x

func _physics_process(delta: float) -> void:
	# Bevæg fremad (langs Z-aksen)
	velocity = Vector3(0, 0, -speed)
	move_and_slide()
