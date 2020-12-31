extends Node2D

signal dead

var HP = 5000

func _ready():
	# signal 연결
	var world = get_tree().root.get_node_or_null("World")
	if world != null:
		connect("dead", world, "on_Player_dead")
		
	$HPBar.init(HP)
	add_to_group("player")
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	on_take_damage()
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func on_take_damage():
	# Flicker 4 times
	for i in 4:
		$Body.modulate.r = 1
		$Body.modulate.g = 0
		$Body.modulate.b = 0
		$Body.modulate.a = 0.5
		yield(get_tree(), "idle_frame")
		$Body.modulate.r = 1
		$Body.modulate.g = 1
		$Body.modulate.b = 1
		$Body.modulate.a = 1.0
		yield(get_tree(), "idle_frame")
		
func die():
	$Body.die()
	
	# dead signal
	emit_signal("dead")

