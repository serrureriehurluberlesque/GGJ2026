extends TextureRect

var t = 0

var credits2 = false

func _input(event):
	if event.is_pressed() and t >= 1.0 and credits2:
		# Global.SKIP = true
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")
	if event.is_pressed() and t >= 1.0 and not credits2:
		$Credits2.show()
		credits2 = true
		t = 0
	

func _process(delta: float) -> void:
	t += delta
