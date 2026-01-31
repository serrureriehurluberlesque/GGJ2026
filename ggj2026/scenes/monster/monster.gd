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

var params_sides = {
	"left": {"pos": Vector2(480, 0), "init_function": set_mask_left}, 
	"center": {"pos": Vector2(860, 0), "init_function": set_mask_center}, 
	"right": {"pos": Vector2(1340, 0), "init_function": set_mask_right},
}

var ypos_from_step = {
	0: 0.27,
	1: 0.28,
	2: 0.30,
	3: 0.32,
	4: 0.34,
	5: 0.37,
	6: 0.40,
	7: 0.43,
	8: 0.46,
	9: 0.5,
	10: 0.55,
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
		new_monster.steps.append((i + 0.5) / NBR_STEPS)
	return new_monster

func _ready():
	params_sides[side]["init_function"].call()
	
	update_progress_pos()
	
	if debug:
		print("Raaarg, i'm a monster at %s" % get_global_position())

func set_mask_left():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_side.png" % type)
	$Sprite2D.set_position(Vector2(0, $Sprite2D.texture.get_height() / -2.0))

func set_mask_center():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_front.png" % type)
	$Sprite2D.set_position(Vector2(0, $Sprite2D.texture.get_height() / -2.0))

func set_mask_right():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_side.png" % type)
	$Sprite2D.flip_h = true
	$Sprite2D.set_position(Vector2(0, $Sprite2D.texture.get_height() / -2.0))

func _physics_process(delta):
	if not knsea:
		#if debug and visible:
			#print("on me %s voit plus" % name)
		hide()
		if mask == type:
			progress_flee = min(1.0, progress_flee + delta * speed * 3.0)
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
		#if debug and not visible:
			#print("on me %s voit" % name)
		show()

func update_progress_pos():
	set_global_position(params_sides[side]["pos"] + Vector2((randf() - 0.5) * 300.0, 2160 * ypos_from_step[step]))
	var scale_factor = 2.0 / ((1 - progress) * 20.0 + 1) * progress
	set_scale(Vector2(scale_factor, scale_factor))
	z_index = step
	var dbdelta = -5 * (12.0 - step)
	if debug:
		print("i make a pas at step %s" % step)
		print(get_global_position())
	$AudioStreamPlayer2D.volume_db = dbdelta
	$AudioStreamPlayer2D.play()

func update_knsea(k):
	knsea = k

func update_masks(m):
	mask = m
