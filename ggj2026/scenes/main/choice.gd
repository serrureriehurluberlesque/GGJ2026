extends TextureRect

func _on_yes_pressed() -> void:
	Global.gentil = false
	$StartSound.play()
	await $StartSound.finished
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _on_no_pressed() -> void:
	Global.gentil = true
	$StartSound.play()
	await $StartSound.finished
	get_tree().change_scene_to_file("res://scenes/main/main.tscn")
