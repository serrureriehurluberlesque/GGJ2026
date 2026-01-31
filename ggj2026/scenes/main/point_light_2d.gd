extends PointLight2D

var min_energy = 0.8
var max_energy = 1.2
var min_time = 0.05
var max_time = 0.1

func _ready():
	while true:
		energy = randf_range(min_energy, max_energy)
		await get_tree().create_timer(randf_range(min_time, max_time)).timeout
