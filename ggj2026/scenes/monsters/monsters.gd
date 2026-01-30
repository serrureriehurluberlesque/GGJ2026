class_name Monsters
extends Node2D

signal win

var BASE_TIME_MONSTER_SPAWN = 5.0
var TIME_MONSTER_RANDF = 10.0
var TIME_MONSTER_COEF = 1.0

var MIN_NBR_MONSTERS = 6
var MAX_NBR_MONSTERS = 9

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
	var new_monster = monster.instantiate()
	add_child(new_monster)
	
	next_monster()
