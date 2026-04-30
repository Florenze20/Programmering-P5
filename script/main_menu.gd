extends Node2D
	

func _on_button_pressed():
	get_tree().change_scene_to_file("res://scene/settings.tscn")
	
#sadaskjd
#Edgen er sej
#Grabas er også sej
#Alle i denne gruppe er mega seje
func _on_quit_pressed():
	get_tree().quit()
	
#changes




func _on_start_pressed():
	get_tree().change_scene_to_file("res://scene/map.tscn")
