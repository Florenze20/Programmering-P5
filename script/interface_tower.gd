extends Node2D

var time = 0
var start_y = 0
var mouse_on_interface = false

# Svæve animation til BoxInterface til towers
func _ready():
	start_y = $BoxInterface.position.y

#stopper animationen når musen er på interface
func _process(delta):
	var mouse_pos = get_global_mouse_position()
	var box_rect = Rect2(
		$BoxInterface.global_position,
		$BoxInterface.size
	)

	mouse_on_interface = box_rect.has_point(mouse_pos)

	if mouse_on_interface:
		return

	time += delta
	$BoxInterface.position.y = start_y + sin(time * 2) * 10
