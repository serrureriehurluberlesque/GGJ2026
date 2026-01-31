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

func _ready() -> void:
	if DEBUG:
		Engine.time_scale = 2.0
	
	$Camera/MaskOn.position = Vector2(0.0, HEIGHT)
	$Monsters.debug = DEBUG
	$Monsters.start()

func _input(event):
	if camera_pos == "up":
		if event.is_action_pressed("ui_down"):
			camera_trans(CAMERA_DOWN)
			camera_pos = "down"
	else:
		if event.is_action_pressed("ui_up"):
			camera_trans(CAMERA_UP)
			camera_pos = "up"
			send_visibility_to_monsters()
		elif event.is_action_pressed("activate"):
			# Switch light
			light_on = !light_on
			%bg_off.visible = !light_on
			$Monsters.update_knsea(light_on)
	
	if mask_on and event.is_action_pressed("click"):
		# Remove mask
		$AnimationPlayer.play("mask_off")
		find_child("mask_%s" % mask_on).remove_mask()
		send_visibility_to_monsters()
		mask_on = 0
		$Monsters.update_masks(mask_on)
		
func camera_trans(new_pos):
	var tween = create_tween().set_trans(Tween.TRANS_SINE).tween_property($Camera, "position", new_pos, TRANS_TIME)
	if new_pos == CAMERA_DOWN:
		await tween.finished
		send_visibility_to_monsters()
		
func send_visibility_to_monsters():
	$Monsters.update_knsea(light_on and camera_pos == "up" and not mask_on)

func _on_mask_on(type: int) -> void:
	$AnimationPlayer.play("mask_on")
	mask_on = type
	$Monsters.update_masks(type)
	send_visibility_to_monsters()
