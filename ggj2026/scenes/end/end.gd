extends Node2D

var t = 0

func _ready() -> void:
	if Global.type == 0:
		Global.type = randi_range(1, 3)
	%Jumpscare.texture = load("res://scenes/end/assets/jumpscare_%d.png" % Global.type)
	%Jumpscare/WAAAH.play()
	%Jumpscare/Timer.start()

func _on_jumpscare_timer_timeout() -> void:
	print("game over")
	%GameOver.visible = true
	t = 0

func _input(event):
	if event.is_pressed() and t >= 1.0 and %GameOver.visible == true:
		get_tree().change_scene_to_file("res://scenes/credits/credits.tscn")

func _process(delta: float) -> void:
	t += delta
