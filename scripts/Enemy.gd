extends Node2D

signal dead

export var HP = 3000

# Called when the node enters the scene tree for the first time.
func _ready():
	# signal 연결
	var world = get_tree().root.get_node_or_null("World")
	if world != null:
		connect("dead", world, "on_enemy_dead")
		
	$HPBar.init(HP)
	add_to_group("enemy")
	

# 이 적을 죽이면 받는 score
func get_score()->int:
	return $HPBar.max_value
		
# damage 를 준다.
func damage(power):
	HP = HP - power
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func die():
	$Body.die()
	
	# enemy가 죽을때 마다 player의 점수를 올린다
	StaticData.current_score_for_stage += get_score()
	
	# dead signal
	emit_signal("dead")
	
	# 3초뒤 삭제
	yield(get_tree().create_timer(3), "timeout")
	call_deferred("queue_free")

func get_body()->Node:
	return $Body
	

