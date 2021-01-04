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
	on_take_damage(power)
	
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func on_take_damage(power):
	var ins = Preloader.hud.instance()
	ins.message = str(power as int)
	add_child(ins)
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
		
func die():
	$Body.die()
	
	# dead signal
	emit_signal("dead")

