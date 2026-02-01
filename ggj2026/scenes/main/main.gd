extends Node

var DEBUG = false

# TODO: less hard-coded ?
var WIDTH = 1920
var HEIGHT = 1080

var TRANS_TIME = 0.5
var CAMERA_UP = Vector2(WIDTH*0.5, HEIGHT*0.5)
var CAMERA_DOWN = Vector2(WIDTH*0.5, HEIGHT*1.5)

var LIGHT_OFF_MIN = 60.0 # sec
var LIGHT_OFF_MAX = 120.0 # sec
var FLICKER_MIN = 10.0 # sec
var FLICKER_MAX = 20.0 # sec

# State variables
var camera_pos = "up"
var light_on = true
var mask_on = 0
var knsea = true
var is_tweening = false
var introed = false
var first_inputed = false
var menued = false

func _ready() -> void:
	$menu_25.show()
	
	if DEBUG:
		Engine.time_scale = 2.0
		Global.SKIP = true
	$Monsters.debug = DEBUG
	
	$Camera/MaskOn.show()
	
	$Camera/TransTimer.wait_time = TRANS_TIME
	$Camera/MaskOn.position = Vector2(0.0, 2*HEIGHT)
	

func start():
	%Light/Timer.wait_time = randf_range(LIGHT_OFF_MIN, LIGHT_OFF_MAX)
	%Light/Timer.start()
	
	%Light/FlickerTimer.wait_time = randf_range(FLICKER_MIN, FLICKER_MAX)
	%Light/FlickerTimer.start()

func intro() -> void:
	$menu_25.hide()
	switch_light(true)
	await get_tree().create_timer(2.0).timeout
	camera_trans(CAMERA_DOWN)
	await $Camera/TransTimer.timeout
	await get_tree().create_timer(1.0).timeout
	$AnimationPlayer.play("intro")

func intro_second_part() -> void:
	$AudioStreamPlayer.stop()
	$Sound2.play()
	camera_trans(CAMERA_UP)
	camera_pos = "up"
	await $Camera/TransTimer.timeout
	send_visibility_to_monsters()
	introed = true
	start()

func _input(event):
	if not menued:
		if event.is_pressed():
			menued = true
			if Global.SKIP:
				first_inputed = true
				introed = true
				$Monsters.start()
				$menu_25.hide()
				switch_light(true)
				$AudioStreamPlayer.stop()
				start()
			else:
				intro()
		return
	if introed and not first_inputed and event.is_pressed():
		$Monsters.start()
		first_inputed = true
	if introed:
		if camera_pos == "up":
			if event.is_action_pressed("ui_down"):
				camera_trans(CAMERA_DOWN)
		else:
			if event.is_action_pressed("ui_up"):
				camera_trans(CAMERA_UP)
				camera_pos = "up"
				send_visibility_to_monsters()
			elif event.is_action_pressed("activate"):
				switch_light()
		
		if mask_on and event.is_action_pressed("click") and not $AnimationPlayer.is_playing():
			# Remove mask
			$AnimationPlayer.play("mask_off")
			find_child("mask_%s" % mask_on).put_mask_back()
		
func i_can_see():
	mask_on = 0
	send_visibility_to_monsters()
	$Monsters.update_masks(mask_on)
	
func soft_switch_light():
	if light_on:
		$AnimationPlayer.play("light_off")
	else:
		$AnimationPlayer.play("light_on")
	
func switch_light(force=null):
	if force != null:
		light_on = force
	else:
		light_on = !light_on
	
	%bg_light.modulate = Color("#fff") if light_on else Color("#3b3b3b")
	%Light/LightSource.enabled = light_on
	send_visibility_to_monsters()
	
	if light_on:
		%Light/LampLoop.play()
	else:
		%Light/LampLoop.stop()
		
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
	if introed:
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


func _on_monsters_gotcha(type: int) -> void:
	Global.type = type
	get_tree().change_scene_to_file("res://scenes/end/end.tscn")


func _on_light_timer_timeout() -> void:
	$AnimationPlayer.play("light_off")
	%Light/Timer.wait_time = randf_range(LIGHT_OFF_MIN, LIGHT_OFF_MAX)
	%Light/Timer.start()


func _on_lantern_light_toggled() -> void:
	soft_switch_light()  # TODO: only on ?


func _on_flicker_timer_timeout() -> void:
	print("FLICKER")
	$AnimationPlayer.play("lamp_flicker")
