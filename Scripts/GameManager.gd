extends Node

var hp = 100

func _process(float) -> void:
	print(hp)
	if hp <= 0:
		get_tree().reload_current_scene()
		hp = 100
