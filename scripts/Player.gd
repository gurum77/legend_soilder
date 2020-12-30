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
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func die():
	$Body.die()
	
	# dead signal
	emit_signal("dead")

