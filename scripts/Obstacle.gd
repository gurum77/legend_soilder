extends Node2D

class_name Obstacle

export var HP = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	$HPBar.init(HP)
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		$Body.die()
