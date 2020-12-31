extends Node2D

class_name Obstacle

export var HP = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	$HPBar.init(HP)
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	on_take_damage()
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		$Body.die()

func on_take_damage():
	# Flicker 4 times
	for i in 4:
		modulate.r = 1
		modulate.g = 0
		modulate.b = 0
		modulate.a = 0.5
		yield(get_tree(), "idle_frame")
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
		modulate.a = 1.0
		yield(get_tree(), "idle_frame")
