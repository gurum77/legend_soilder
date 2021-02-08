extends Node2D

class_name Obstacle

export var HP = 3000
onready var hp_bar = get_node_or_null("HPBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	if hp_bar != null:
		hp_bar.init(HP)
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	on_take_damage()
	if hp_bar != null:
		hp_bar.set_hp(HP)
	if HP <= 0:
		HP = 0
		$Body.die()

func on_take_damage():
	for i in 1:
		modulate.r = 0.5
		modulate.g = 1
		modulate.b = 1
		modulate.a = 0.9
		yield(get_tree().create_timer(0.05), "timeout")
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
		modulate.a = 1.0
		
