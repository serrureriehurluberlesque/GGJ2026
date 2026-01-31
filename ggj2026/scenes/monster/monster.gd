class_name Monster
extends Node2D

signal flee(monster)
signal goth_ya(type)

const monster_scene: PackedScene = preload("res://scenes/monster/monster.tscn")

var type: int
var side: String
var knsea: bool
var mask: int
var debug: bool

var steps:= []
var progress:= 0.0
var progress_flee:= 0.0
var step:= 0

var params_sides = {
	"left": {"pos": Vector2(480, 300), "init_function": set_mask_left}, 
	"center": {"pos": Vector2(860, 300), "init_function": set_mask_center}, 
	"right": {"pos": Vector2(1340, 300), "init_function": set_mask_right},
}

static func new_monster(type: int, side: String, total_time: float, knsea: bool, mask: int, debug: bool) -> Monster:
	var new_monster: Monster = monster_scene.instantiate()
	new_monster.type = type
	new_monster.side = side
	new_monster.knsea = knsea
	new_monster.mask = mask
	new_monster.debug = debug
	return new_monster

func _ready():
	params_sides[side]["init_function"].call()
	
	update_progress_pos()
	
	if debug:
		print("Raaarg, i'm a monster at %s" % get_global_position())

func set_mask_left():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_side.png" % type)

func set_mask_center():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_front.png" % type)

func set_mask_right():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_side.png" % type)
	$Sprite2D.flip_h = true

func _physics_process(delta):
	if not knsea:
		hide()
		if mask == type:
			progress_flee += delta * 0.15
			if progress_flee >= 1.0:
				flee.emit(self)
		else:
			progress += delta * 0.05
			update_progress_pos()
			if progress:
				goth_ya.emit(type)
	else:
		show()

func update_progress_pos():
	set_global_position(params_sides[side]["pos"] + Vector2(0, progress * 500.0))
	var scale_factor = 1.0 / ((1 - progress) * 100.0 + 1)
	set_scale(Vector2(scale_factor, scale_factor))

func update_knsea(k):
	knsea = k

func update_masks(m):
	mask = m
