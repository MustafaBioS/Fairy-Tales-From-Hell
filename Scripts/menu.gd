extends Control
var enemy = null


func _on_button_pressed() -> void:
	enemy = "shrek"
	get_tree().change_scene_to_file("res://scenes/game.tscn")

	
func _on_button_2_pressed() -> void:
	enemy = "harry"
	get_tree().change_scene_to_file("res://scenes/game.tscn")
