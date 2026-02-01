class_name Monsters
extends Node2D

signal win
signal gotcha(type)

var BASE_TIME_MONSTER_SPAWN = 22.0
var TIME_MONSTER_RANDF = 5.0
var TIME_MONSTER_COEF = 1.5
var VISIBLE_SLOW_SPAWN_COEF = 0.25

var SPEED_MONSTER = 20.0

var MIN_NBR_MONSTERS = 6
var MAX_NBR_MONSTERS = 9

var spawn_sides = ["left", "center", "right"]

var next_monsters = []

var monster
var nbr_monster = 0

var knsea:= true
var mask:= 0
var started:= false

var debug = false

func _ready():
	monster = load("res://scenes/monster/monster.tscn")
	
	$TimerNextMonster.connect("timeout", spawn_monster)
	for i in randi_range(MIN_NBR_MONSTERS, MAX_NBR_MONSTERS):
		next_monsters.append(BASE_TIME_MONSTER_SPAWN - TIME_MONSTER_COEF * i + randf() * TIME_MONSTER_RANDF)
	
	if get_tree().current_scene == self:  # si c'est pas la main scene, faudra call start() pour que ça commence
		start()
		knsea = false
		debug = true

func _physics_process(delta):
	if started:
		$TimerNextMonster.set_paused(randf() <= VISIBLE_SLOW_SPAWN_COEF and knsea)

func start():
	next_monster()
	started = true
	
func next_monster():
	nbr_monster += 1
	if debug:
		print("sstarting to spawn monster %s" % nbr_monster)
	if next_monsters:
		if debug and nbr_monster == 1:
			$TimerNextMonster.start(1.0)
		else:
			$TimerNextMonster.start(next_monsters.pop_front())

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
			if nbr_monster == 1:
				total_time *= 3
			else:
				total_time - nbr_monster
			var new_monster = Monster.new_monster(type, side, total_time, knsea, mask, debug)
			$Monsters.add_child(new_monster)
			new_monster.connect("flee", monster_flee)
			new_monster.connect("goth_ya", goth_ya)
			
			if nbr_monster == 1:
				return
			else:
				next_monster()
		else:
			$TimerNextMonster.start(2.0)
	else:
		$TimerNextMonster.start(0.1)

func update_knsea(k):
	if debug:
		print("on me voit" if k else "on me voit plus")
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
	if nbr_monster == 1:
		next_monster()
	
	m.queue_free()
	
	await get_tree().create_timer(2.0).timeout
	
	if not next_monsters and not $Monsters.get_children():
		win.emit()

func goth_ya(type):
	gotcha.emit(type)
