class_name Monsters
extends Node2D

signal win

var BASE_TIME_MONSTER_SPAWN = 5.0
var TIME_MONSTER_RANDF = 10.0
var TIME_MONSTER_COEF = 1.0

var SPEED_MONSTER = 10.0

var MIN_NBR_MONSTERS = 6
var MAX_NBR_MONSTERS = 9

var spawn_sides = {
	"left": {"monsters": []}, 
	"center": {"monsters": []}, 
	"right": {"monsters": []},
}

var next_monsters = []

var monster

func _ready():
	monster = load("res://scenes/monster/monster.tscn")
	
	$TimerNextMonster.connect("timeout", spawn_monster)
	for i in randi_range(MIN_NBR_MONSTERS, MAX_NBR_MONSTERS):
		next_monsters.append(BASE_TIME_MONSTER_SPAWN + randf() * (TIME_MONSTER_RANDF - TIME_MONSTER_COEF * i))
	
	next_monster()

func next_monster():
	if next_monsters:
		$TimerNextMonster.start(next_monsters.pop_front())
	else:
		win.emit()

func spawn_monster():
	var empty_side = []
	for s in spawn_sides.keys():
		if not spawn_sides[s]["monsters"]:
			empty_side.append(s)
	
	if empty_side:
		var side = empty_side.pick_random()
		var type = randi_range(1, 3)
		var total_time = SPEED_MONSTER
		var new_monster = Monster.new_monster(type, side, total_time)
		add_child(new_monster)
		spawn_sides[side]["monsters"].append(new_monster)
		
		next_monster()
	else:
		$TimerNextMonster.start(1.0)
