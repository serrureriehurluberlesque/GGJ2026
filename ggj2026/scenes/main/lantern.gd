extends Sprite2D

signal light_toggled

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		light_toggled.emit()
