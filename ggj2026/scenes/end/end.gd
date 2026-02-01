extends Node2D

var t = 0

func _ready() -> void:
	if Global.type == 0:
		Global.type = randi_range(1, 3)
	if Global.type == -1:
		%Jumpscare.texture = load("res://scenes/end/assets/Victory.png")
		%Jumpscare/win.play()
	else:
		if Global.gentil:
			%Jumpscare.texture = load("res://scenes/end/assets/Jumpscare_gentil_%d.png" % Global.type)
		else:
			%Jumpscare.texture = load("res://scenes/end/assets/jumpscare_%d.png" % Global.type)
			%Jumpscare/WAAAH.play()
		%Jumpscare/Timer.start()

func _on_jumpscare_timer_timeout() -> void:
	%GameOver.visible = true
	$GameOver/AudioStreamPlayer.play()
	t = 0
	
	await get_tree().create_timer(5.0).timeout
	get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")

func _input(event):
	if event.is_pressed() and t >= 2.0 and (%GameOver.visible == true or Global.type == -1):
		get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")

func _process(delta: float) -> void:
	t += delta
