extends Node2D
class_name Enemy
signal dead
signal added
signal removed

export var HP = 3000
export var minimap_icon = "mob"

onready var score = HP
onready var max_HP = HP

enum DamageType{normal, critical, headshot}

# Called when the node enters the scene tree for the first time.
func _ready():
	# signal 연결
	var world = get_tree().root.get_node_or_null("World")
	if world != null:
		var err = connect("dead", world, "on_Enemy_dead")
		if err != OK:
			push_error("connect failed")
		
	var minimap = get_tree().root.get_node_or_null("World/CanvasLayer/MiniMap")
	if minimap != null:
		var err = connect("added", minimap, "on_Object_added")
		if err != OK:
			push_error("connect failed")
		err = connect("removed", minimap, "on_Object_removed")
		if err != OK:
			push_error("connect failed")
		emit_signal("added", self)
	set_HP(HP)
	add_to_group("enemy")
	
# path_finder를 설정한
func set_path_finder(var path_finder):
	var ai_move = get_node_or_null("EnemyAI/EnemyAI_Move")
	if ai_move != null:
		ai_move.path_finder = path_finder;
	
# hp를 설정한다.
func set_HP(hp):
	HP = hp
	score = HP
	max_HP = HP
	$HPBar.init(HP)
	
# 이 적을 죽이면 받는 score
func get_score()->int:
	return score
	
# damage type
# 헤드샷 : 5% 확률
# 크리티컬 : 10% 확률
func get_damage_type()->int:
	var v = rand_range(0, 100)
	if v < 5:
		return DamageType.headshot
	elif v < 15:
		return DamageType.critical
	return DamageType.normal
	
func get_power_by_type(var power, var damage_type)->int:
	if damage_type == DamageType.critical:
		return power * 3
	elif damage_type == DamageType.headshot:
		return power * 5
	return power
	
# damage 를 준다.
func damage(power):
	var dt = get_damage_type()
	power = get_power_by_type(power, dt)
	
	HP = HP - power
	on_take_damage(power, dt)
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()
		make_item()
		
	
func make_item():
	var item_maker = get_node_or_null("ItemMaker")
	if item_maker != null:
		item_maker.make_item(max_HP)
	
func on_take_damage(power, damage_type):
	var ins = Preloader.hud.instance()
	ins.message = str(-power as int)
	if damage_type == DamageType.critical:
		ins.color = Color.orange
		ins.scale = Vector2(1.3, 1.3)
	elif damage_type == DamageType.headshot:
		ins.color = Color.red
		ins.scale = Vector2(2, 2)
	
	add_child(ins)
	
	for i in 1:
		modulate.r = 0.5
		modulate.g = 1
		modulate.b = 1
		modulate.a = 0.6
		yield(get_tree().create_timer(0.05), "timeout")
		modulate.r = 1
		modulate.g = 1
		modulate.b = 1
		modulate.a = 1.0
		
func die():
	$Body.die()
	
	# 자동차나 비행기가 파괴돌때는 카메라를 흔든다.
	if $Body.enemy_type != EnemyBody.EnemyType.normal:
		Util.shake_camera()
	
	# enemy가 죽을때 마다 player의 점수를 올린다
	StaticData.current_score_for_stage += get_score()
	
	# enemy가 죽을때 올리는 점수를 경험치에 반영한다.
	StaticData.total_exp += get_score()
	
	# dead signal(world에서 제거)
	emit_signal("dead")
	# removed signal(미니맵에서 제거)
	emit_signal("removed", self)
	
	# 3초뒤 삭제
	yield(get_tree().create_timer(3), "timeout")
	call_deferred("queue_free")
	
	

func get_body()->Node:
	return $Body
	
# body의 collision의 크기를 가져온다.
func get_body_collision_size()->float:
	var size:float = 1
	var nodes = get_body().get_children()
	for node in nodes:
		if not node is CollisionShape2D:
			continue;
		var cs:CollisionShape2D = node
		
		var s = get_collision_size(cs.shape)
		if size < s:
			size = s
			
	return size
	
# collision의 크기를 리턴한다.
# 가로 세로 중 큰 값을 리턴한다.
# rectangle, circle, capsule 만 계산 가능
# 다른거를 사용하면 추가 코딩해야
func get_collision_size(shape)->float:
	var size:float = 1.0
	if shape is CapsuleShape2D:
		size = shape.height + shape.radius*2
	elif shape is CircleShape2D:
		size = shape.radius * 2
	elif shape is RectangleShape2D:
		size = max(shape.extents.x, shape.extents.y) * 2
	else:
		push_error("정의 되지 않은 shape type입니다.")
	
	return size
	
	
	



func _on_Timer_timeout():
	pass # Replace with function body.

