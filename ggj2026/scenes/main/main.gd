extends Node

var DEBUG = true

# TODO: less hard-coded ?
var 	WIDTH = 1920
var HEIGHT = 1080

var TRANS_TIME = 0.5
var CAMERA_UP = Vector2(WIDTH*0.5, HEIGHT*0.5)
var CAMERA_DOWN = Vector2(WIDTH*0.5, HEIGHT*1.5)

# State variables
var camera_pos = "up"
var light_on = true
var mask_on = 0
var knsea = true
var is_tweening = false

func _ready() -> void:
	if DEBUG:
		Engine.time_scale = 2.0
	
	$Camera/TransTimer.wait_time = TRANS_TIME
	$Camera/MaskOn.position = Vector2(0.0, HEIGHT)
	$Monsters.debug = DEBUG
	$Monsters.start()

func _input(event):
	if camera_pos == "up":
		if event.is_action_pressed("ui_down"):
			camera_trans(CAMERA_DOWN)
	else:
		if event.is_action_pressed("ui_up"):
			camera_trans(CAMERA_UP)
			camera_pos = "up"
			send_visibility_to_monsters()
		elif event.is_action_pressed("activate"):
			# Switch light
			light_on = !light_on
			%bg_light.modulate = Color("#fff") if light_on else Color("#3b3b3b")
			send_visibility_to_monsters()
	
	if mask_on and event.is_action_pressed("click") and not $AnimationPlayer.is_playing():
		# Remove mask
		$AnimationPlayer.play("mask_off")
		find_child("mask_%s" % mask_on).put_mask_back()
		
func i_can_see():
	mask_on = 0
	send_visibility_to_monsters()
	$Monsters.update_masks(mask_on)
		
func camera_trans(new_pos):
	create_tween().set_trans(Tween.TRANS_SINE).tween_property($Camera, "position", new_pos, TRANS_TIME)
	camera_pos = "trans"
	$Camera/TransTimer.start()
		
func send_visibility_to_monsters():
	var new_knsea = light_on and camera_pos != "down" and not mask_on
	if new_knsea != knsea:
		knsea = new_knsea
		$Monsters.update_knsea(knsea)

func _on_mask_chosen(type: int) -> void:
	if mask_on == 0:
		mask_on = type
		find_child("mask_%s" % mask_on).take_mask()
		$AnimationPlayer.play("mask_on")
		$Monsters.update_masks(mask_on)
		send_visibility_to_monsters()

func _on_trans_timer_timeout() -> void:
	if $Camera.position == CAMERA_DOWN:
		camera_pos = "down"
		send_visibility_to_monsters()
