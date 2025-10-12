extends Control
var enemy = null

func _on_button_pressed() -> void:
	print("shrek")
	enemy = "shrek"
	get_tree().change_scene_to_file("res://scenes/shrek.tscn")

	
func _on_button_2_pressed() -> void:
	print("harry")
	enemy = "harry"
	get_tree().change_scene_to_file("res://scenes/harry.tscn")
