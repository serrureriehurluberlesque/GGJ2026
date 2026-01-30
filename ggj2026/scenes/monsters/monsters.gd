class_name Monsters
extends Node2D

signal win

var BASE_TIME_MONSTER_SPAWN = 5.0
var TIME_MONSTER_RANDF = 10.0
var TIME_MONSTER_COEF = 1.0

var MIN_NBR_MONSTERS = 6
var MAX_NBR_MONSTERS = 9

var SPAWN_Y = 400

var spawn_sides = {
	"left": {"pos": Vector2(200, 200), "monsters": [], "mask": set_mask_left}, 
	"center": {"pos": Vector2(400, 200), "monsters": [], "mask": set_mask_center}, 
	"right": {"pos": Vector2(600, 200), "monsters": [], "mask": set_mask_right},
}

var next_monsters = []

var monster

func _ready():
	monster = load("res://scenes/monster/monster.tscn")
	
	$TimerNextMonster.connect("timeout", spawn_monster)
	for i in randi_range(MIN_NBR_MONSTERS, MAX_NBR_MONSTERS):
		next_monsters.append(BASE_TIME_MONSTER_SPAWN + randf() * (TIME_MONSTER_RANDF - TIME_MONSTER_COEF * i))
	
	next_monster()

func set_mask_left(monster):
	monster.get_node("Sprite2D").texture = load("res://scenes/monster/assets/mask_1_front.png")
	
func set_mask_center(monster):
	monster.get_node("Sprite2D").texture = load("res://scenes/monster/assets/mask_1_front.png")
	
func set_mask_right(monster):
	monster.get_node("Sprite2D").texture = load("res://scenes/monster/assets/mask_1_front.png")

func next_monster():
	if next_monsters:
		$TimerNextMonster.start(next_monsters.pop_front())
	else:
		win.emit()

func spawn_monster():
	var new_monster = monster.instantiate()
	var empty_side = []
	for s in spawn_sides.keys():
		if not spawn_sides[s]["monsters"]:
			empty_side.append(s)
	var side = empty_side.pick_random()
	
	if empty_side:
		add_child(new_monster)
		spawn_sides[side]["monsters"].append(new_monster)
		new_monster.set_position(spawn_sides[side]["pos"])
		new_monster.set_scale(Vector2(0.25, 0.25))
		spawn_sides[side]["mask"].call(new_monster)
		
		next_monster()
	else:
		$TimerNextMonster.start(1.0)
