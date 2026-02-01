class_name Monster
extends Node2D

signal flee(monster)
signal goth_ya(type)

const monster_scene: PackedScene = preload("res://scenes/monster/monster.tscn")
const NBR_STEPS := 10

var type: int
var side: String
var knsea: bool
var mask: int
var debug: bool

var steps:= []
var progress:= 0.0
var speed:= 0.05
var progress_flee:= 0.0
var step:= 0

var t = 1.0

var started_sound := false

var properties_from_step = {
	0: {"scale": 0.1, "alpha": 0.2, "dark": 0.00, "poss": {
		"left": [Vector2(110, 690)], 
		"center": [Vector2(1060, 790)],
		"right": [Vector2(1660, 690)],
		}},
	1: {"scale": 0.11, "alpha": 0.35, "dark": 0.0, "poss": {
		"left": [Vector2(110, 690)], 
		"center": [Vector2(1060, 790)],
		"right": [Vector2(1660, 690)],
		}},
	2: {"scale": 0.12, "alpha": 0.5, "dark": 0.05, "poss": {
		"left": [Vector2(380, 775)], 
		"center": [Vector2(915, 795)],
		"right": [Vector2(1790, 770)],
		}},
	3: {"scale": 0.14, "alpha": 0.5, "dark": 0.07, "poss": {
		"left": [Vector2(380, 775)], 
		"center": [Vector2(915, 795)],
		"right": [Vector2(1790, 770)],
		}},
	4: {"scale": 0.2, "alpha": 1.0, "dark": 0.35, "poss": {
		"left": [Vector2(380, 905)], 
		"center": [Vector2(975, 1010)],
		"right": [Vector2(1425, 965)],
		}},
	5: {"scale": 0.27, "alpha": 1.0, "dark": 0.45, "poss": {
		"left": [Vector2(380, 905)], 
		"center": [Vector2(975, 1010)],
		"right": [Vector2(1425, 965)],
		}},
	6: {"scale": 0.35, "alpha": 1.0, "dark": 0.55, "poss": {
		"left": [Vector2(430, 1210)], 
		"center": [Vector2(1120, 1220)],
		"right": [Vector2(1730, 1130)],
		}},
	7: {"scale": 0.5, "alpha": 1.0, "dark": 0.6, "poss": {
		"left": [Vector2(430, 1210)], 
		"center": [Vector2(1120, 1220)],
		"right": [Vector2(1730, 1130)],
		}},
	8: {"scale": 0.62, "alpha": 1.0, "dark": 0.65, "poss": {
		"left": [Vector2(430, 1210)], 
		"center": [Vector2(1120, 1220)],
		"right": [Vector2(1730, 1130)],
		}},
	9: {"scale": 0.78, "alpha": 1.0, "dark": 0.75, "poss": {
		"left": [Vector2(420, 1200)],
		"center": [Vector2(960, 1200)],
		"right": [Vector2(1500, 1200)],
		}},
	10: {"scale": 1.0, "alpha": 1.0, "dark": 1.0, "poss": {
		"left": [Vector2(420, 1200)], 
		"center": [Vector2(960, 1200)],
		"right": [Vector2(1500, 1200)],
		}},
}

static func new_monster(type: int, side: String, total_time: float, knsea: bool, mask: int, debug: bool) -> Monster:
	var new_monster: Monster = monster_scene.instantiate()
	new_monster.type = type
	new_monster.side = side
	new_monster.knsea = knsea
	new_monster.mask = mask
	new_monster.debug = debug
	new_monster.speed = 1.0 / total_time
	for i in range(NBR_STEPS + 1):
		new_monster.steps.append((i + randf()) / NBR_STEPS)
	return new_monster

func _ready():
	set_mask_texture()
	
	update_progress_pos()
	
	if debug:
		print("Raaarg, i'm a monster at %s" % get_global_position())
		
func set_mask_texture():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_front.png" % type)
	$Sprite2D.set_position(Vector2(50, -455))
	$AudioStreamPlayer2D.stream = load("res://scenes/monster/assets/sound_monster_%d.ogg" % type)

func _physics_process(delta):
	if step >= 3:
		t += delta
		if not knsea and mask != type:
			if $AudioStreamPlayer2D.stream_paused:
				t += delta * randf() * 0.5
			else:
				t -= delta * randf() * 0.5
		else:
			if $AudioStreamPlayer2D.stream_paused:
				t -= delta * randf() * 0.5
			else:
				t += delta * randf() * 0.5
		
		if $AudioStreamPlayer2D.stream_paused:
			if t > 2.0 + randf():
				t -= 2.5
				$AudioStreamPlayer2D.stream_paused = false
		else:
			if t > 2.0 + randf():
				t -= 2.5
				$AudioStreamPlayer2D.stream_paused = true
		if not knsea:
			if mask == type:
				progress_flee = min(1.0, progress_flee + delta / (speed * 100.0))
				if progress_flee >= 1.0:
					flee.emit(self)
			else:
				progress = min(1.0, progress + delta * speed)

				if progress >= 1.0:
					goth_ya.emit(type)
				elif progress > steps[step]:
					step += 1
					update_progress_pos()
	else:
		progress = min(1.0, progress + delta * speed)
		if progress > steps[step]:
			step += 1
			update_progress_pos()

func update_progress_pos():
	set_global_position(properties_from_step[step]["poss"][side][0])
	set_scale(Vector2(properties_from_step[step]["scale"], properties_from_step[step]["scale"]))
	z_index = step
	var dark_factor = 1.0
	if not knsea:
		if step < 10:
			dark_factor = 0.05
		else:
			dark_factor = 0.5
	modulate = Color(
		properties_from_step[step]["dark"] * 1.0 * dark_factor, 
		properties_from_step[step]["dark"] * 1.0 * dark_factor, 
		properties_from_step[step]["dark"] * 1.0 * dark_factor,
		properties_from_step[step]["alpha"] * 1.0
		)
	if step >= 3 and not started_sound:
		started_sound = true
		$AudioStreamPlayer2D.play()
	var db =  -2 * (8.0 - step)
	if type == 3:
		db += 6
	$AudioStreamPlayer2D.volume_db = db
	if debug:
		print("i make a pas at step %s" % step)
		print(get_global_position())

func update_knsea(k):
	knsea = k
	update_progress_pos()

func update_masks(m):
	mask = m
