extends Node

signal switch_light(on)

# TODO: less hard-coded ?
var 	WIDTH = 1920
var HEIGHT = 1080

var TRANS_TIME = 0.5
var CAMERA_UP = Vector2(WIDTH*0.5, HEIGHT*0.5)
var CAMERA_DOWN = Vector2(WIDTH*0.5, HEIGHT*1.5)
var CAMERA_POS = "up"
var LIGHT_ON = true

func _input(event):
	if CAMERA_POS == "up":
		if event.is_action_pressed("ui_down"):
			camera_trans(CAMERA_DOWN)
			CAMERA_POS = "down"
	else:
		if event.is_action_pressed("ui_up"):
			camera_trans(CAMERA_UP)
			CAMERA_POS = "up"
		elif event.is_action_pressed("activate"):
			# Switch light
			LIGHT_ON = !LIGHT_ON
			%bg_off.visible = !LIGHT_ON
			switch_light.emit(LIGHT_ON)
		
func camera_trans(new_pos):
	create_tween().set_trans(Tween.TRANS_SINE).tween_property($Camera, "position", new_pos, TRANS_TIME)
