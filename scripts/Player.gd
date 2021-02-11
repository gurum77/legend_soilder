extends Node2D
class_name Player
signal dead

var HP = 30000
onready var max_HP = HP

func _ready():
	# signal 연결
	var world = get_tree().root.get_node_or_null("World")
	if world != null:
		var err = connect("dead", world, "on_Player_dead")
		if err != OK:
			push_error("connect failed")
		
	$HPBar.init(HP)
	add_to_group("player")
	

# shield가 활성화 되어 있는지?	
func is_enable_shield()->bool:
	if $Shield.visible:
		return true
	return false
	
# damage 를 준다.
func damage(power):
	if HP < 0:
		return
	if is_enable_shield():
		return
	
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

# 부활한다
func revival():
	HP = max_HP
	$HPBar.set_hp(HP)
	$Body.revival()
	$Shield.start()

# dash를 한다
func dash()->bool:
	var dir:Vector2 = $Body.velocity.normalized()
	if dir == Vector2.ZERO:
		return false
		
	var new_position = position + dir * 70
	$Tween.interpolate_property(self, "position", position, new_position, 0.2, Tween.TRANS_SINE, Tween.EASE_OUT)
	$Tween.start()
	return true
