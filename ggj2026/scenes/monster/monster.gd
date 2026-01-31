class_name Monster
extends Node2D

const monster_scene: PackedScene = preload("res://scenes/monster/monster.tscn")

var type: int
var side: String
var steps: Array
var step: int

var params_sides = {
	"left": {"pos": Vector2(480, 300), "init_function": set_mask_left}, 
	"center": {"pos": Vector2(860, 300), "init_function": set_mask_center}, 
	"right": {"pos": Vector2(1340, 300), "init_function": set_mask_right},
}

static func new_monster(type: int, side: String, total_time: float) -> Monster:
	var new_monster: Monster = monster_scene.instantiate()
	new_monster.type = type
	new_monster.side = side
	new_monster.steps = []
	new_monster.step = 0
	return new_monster

func _ready():
	print("Raaarg, i'm a monster at %s" % get_global_position())
	params_sides[side]["init_function"].call()
	
	set_global_position(params_sides[side]["pos"])
	set_scale(Vector2(0.25, 0.25))

func set_mask_left():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_side.png" % type)
	
func set_mask_center():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_front.png" % type)
	
func set_mask_right():
	$Sprite2D.texture = load("res://scenes/monster/assets/mask_%d_side.png" % type)
	$Sprite2D.flip_h = true
