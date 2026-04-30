extends Node2D


# Called when the node enters the scene tree for the first time.



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float):
	get_tree().change_scene_to_file("res://scene/map.tscn")



func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/settings.tscn")
	
#sadaskjd
#Edgen er sej
#Grabas er også sej
#Alle i denne gruppe er mega seje
func _on_quit_pressed():
	get_tree().quit()
	
#changes


func _on_button_2_pressed() -> void:
	pass # Replace with function body.
