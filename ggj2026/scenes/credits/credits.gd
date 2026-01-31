extends TextureRect

var t = 0

func _input(event):
	if event.is_pressed() and t >= 1.0:
		get_tree().change_scene_to_file("res://scenes/main/main.tscn")

func _process(delta: float) -> void:
	t += delta
