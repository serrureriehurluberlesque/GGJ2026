extends TextureRect

signal chosen

func _on_yes_pressed() -> void:
	Global.gentil = false
	$StartSound.play()
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	chosen.emit()

func _on_no_pressed() -> void:
	Global.gentil = true
	$StartSound.play()
	#get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	chosen.emit()
