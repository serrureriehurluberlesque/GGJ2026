extends TextureRect

func _on_yes_pressed() -> void:
	Global.gentil = false
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_no_pressed() -> void:
	Global.gentil = true
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
