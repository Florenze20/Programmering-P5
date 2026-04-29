extends CharacterBody2D

@export var speed := 40
var hp := 25
var lane_y := 0

func _ready():
	position.y = lane_y
	add_to_group("enemies")

func _physics_process(delta):
	velocity = Vector2(-speed, 0)
	move_and_slide()

func take_damage(amount):
	hp -= amount
	if hp <= 0:
		queue_free()
