extends Node2D

func _ready() -> void:
	%Jumpscare.texture = load("res://scenes/end/assets/jumpscare_%d.png" % Global.type)
	%Jumpscare/Timer.start()

func _on_jumpscare_timer_timeout() -> void:
	print("game over")
	%GameOver.visible = true
