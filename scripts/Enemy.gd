extends Node2D
class_name Enemy
signal dead

export var HP = 3000
onready var score = HP

# Called when the node enters the scene tree for the first time.
func _ready():
	# signal 연결
	var world = get_tree().root.get_node_or_null("World")
	if world != null:
		connect("dead", world, "on_Enemy_dead")
		
	$HPBar.init(HP)
	add_to_group("enemy")
	

# 이 적을 죽이면 받는 score
func get_score()->int:
	return score
		
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
	
	# enemy가 죽을때 마다 player의 점수를 올린다
	StaticData.current_score_for_stage += get_score()
	
	# dead signal
	emit_signal("dead")
	
	# 3초뒤 삭제
	yield(get_tree().create_timer(3), "timeout")
	call_deferred("queue_free")
	
	# money를 떨어뜨린다
	var ins = Preloader.money.instance()
	ins.global_position = global_position
	get_tree().root.add_child(ins)

func get_body()->Node:
	return $Body
	

