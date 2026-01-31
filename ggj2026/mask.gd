extends Node2D

@export var type: int

signal mask_chosen(type)

func _ready():
	%Sprite.texture = load("res://scenes/main/assets/mask_%d_wood.png" % type)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		mask_chosen.emit(type)
		
func take_mask():
	%Anim.play("take_mask")

func put_mask_back():
	%Anim.play("put_mask_back")
