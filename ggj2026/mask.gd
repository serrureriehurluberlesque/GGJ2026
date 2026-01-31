extends Node2D

@export var type: String

signal mask_on(type)

func _ready():
	%Sprite.texture = load("res://scenes/main/assets/mask_%s_wood.png" % type)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event.is_action_pressed("click"):
		%Anim.play("put_on_mask")


func _on_anim_animation_finished(anim_name: StringName) -> void:
	if anim_name == "put_on_mask":
		mask_on.emit(type)

func remove():
	%Anim.play("remove_mask")
