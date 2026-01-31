extends Node2D

@export var type: String

func _ready():
	$Sprite2D.texture = load("res://scenes/main/assets/mask_%s_wood.png" % type)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		print("click")
		%anim.play("slide_off_table")
