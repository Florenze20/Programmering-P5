extends Node2D

var time = 0
var start_y = 0
#Svæve animation til BoxINterface til towers
func _ready():
	start_y = $BoxInterface.position.y

func _process(delta):
	time += delta
	$BoxInterface.position.y = start_y + sin(time * 2) * 10
