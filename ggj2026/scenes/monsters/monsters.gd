class_name Monsters
extends Node2D

signal win
signal gotcha

var BASE_TIME_MONSTER_SPAWN = 5.0
var TIME_MONSTER_RANDF = 10.0
var TIME_MONSTER_COEF = 1.0

var SPEED_MONSTER = 10.0

var MIN_NBR_MONSTERS = 6
var MAX_NBR_MONSTERS = 9

var spawn_sides = ["left", "center", "right"]

var next_monsters = []

var monster

var knsea:= true
var mask:= 0

var debug = false

func _ready():
	monster = load("res://scenes/monster/monster.tscn")
	
	$TimerNextMonster.connect("timeout", spawn_monster)
	for i in randi_range(MIN_NBR_MONSTERS, MAX_NBR_MONSTERS):
		next_monsters.append(BASE_TIME_MONSTER_SPAWN + randf() * (TIME_MONSTER_RANDF - TIME_MONSTER_COEF * i))
	
	if get_tree().current_scene == self:  # si c'est pas la main scene, faudra call start() pour que ça commence
		start()
		knsea = false
		debug = true

func start():
	next_monster()
	
func next_monster():
	if next_monsters:
		$TimerNextMonster.start(next_monsters.pop_front())
	else:
		win.emit()

func spawn_monster():
	if not knsea:
		var empty_side = []
		for s in spawn_sides:
			var is_empty = true
			for m in $Monsters.get_children():
				if m.side == s:
					is_empty = false
					break
			if is_empty:
				empty_side.append(s)
		
		if empty_side:
			var side = empty_side.pick_random()
			var type = randi_range(1, 3)
			var total_time = SPEED_MONSTER
			var new_monster = Monster.new_monster(type, side, total_time, knsea, mask, debug)
			$Monsters.add_child(new_monster)
			new_monster.connect("flee", monster_flee)
			new_monster.connect("goth_ya", goth_ya)
			
			next_monster()
		else:
			$TimerNextMonster.start(2.0)
	else:
		$TimerNextMonster.start(0.1)

func update_knsea(k):
	knsea = k
	transmit_knseamask_monsters()

func update_masks(m):
	mask = m
	transmit_knseamask_monsters()

func transmit_knseamask_monsters():
	for m in $Monsters.get_children():
		m.update_knsea(knsea)
		m.update_masks(mask)

func monster_flee(m):
	m.queue_free()
	
	await get_tree().create_timer(2.0).timeout
	
	if not next_monster() and not $Monsters.get_children():
		win.emit()

func goth_ya(type):
	gotcha.emit(type)
