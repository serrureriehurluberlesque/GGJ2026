extends Node


# TODO: less hard-coded ?
var 	WIDTH = 1920
var HEIGHT = 1080

var TRANS_TIME = 0.5
var CAMERA_UP = Vector2(WIDTH*0.5, HEIGHT*0.5)
var CAMERA_DOWN = Vector2(WIDTH*0.5, HEIGHT*1.5)

# State variables
var camera_pos = "up"
var light_on = true
var mask_on = false

func _ready() -> void:
	$Camera/MaskOn.position = Vector2(0.0, HEIGHT)

func _input(event):
	if camera_pos == "up":
		if event.is_action_pressed("ui_down"):
			camera_trans(CAMERA_DOWN)
			camera_pos = "down"
	else:
		if event.is_action_pressed("ui_up"):
			camera_trans(CAMERA_UP)
			camera_pos = "up"
		elif event.is_action_pressed("activate"):
			# Switch light
			light_on = !light_on
			%bg_off.visible = !light_on
			$Monsters.update_knsea = light_on
	
	if mask_on and event.is_action_pressed("click"):
		$AnimationPlayer.play("mask_off")
		find_child("mask_%s" % mask_on).remove()
		$Monsters.update_masks(0)
		$Monsters.update_knsea = true
		mask_on = null
		
func camera_trans(new_pos):
	create_tween().set_trans(Tween.TRANS_SINE).tween_property($Camera, "position", new_pos, TRANS_TIME)

func _on_mask_on(type: String) -> void:
	$AnimationPlayer.play("mask_on")
	mask_on = type
	$Monsters.update_masks(int(type))
	$Monsters.update_knsea = false
