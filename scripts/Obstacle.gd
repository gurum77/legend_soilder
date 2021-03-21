extends Node2D

class_name Obstacle

# 종류 (걷기만 해도 깨짐, 박스처럼 잘 깨짐, 돌처럼 단단함, 쇠처럼 절대 깨지지 않음
enum Type{broken_by_oneshot, kind_of_box, kind_of_rock, kind_of_steel, kind_of_power_cube }
export (Type) var type
# 랜덤하고 회전하는 각도 단위
export (int) var random_rotation_degree = 0
# 생성되자 마자 사라지는 확률(0 ~ 100)
export (int) var destroy_on_start_up = 0

var HP = 3000	# Type에 따라 HP가 자동으로 정해진다
var max_HP = 3000
onready var hp_bar = get_node_or_null("HPBarNode/HPBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	# 시작하자 마자 사라지는지?
	if destroy_on_start_up > 0:
		var v = rand_range(0, 100)
		if v < destroy_on_start_up:
			call_deferred("queue_free")
			return
			
	# 랜덤회전 단위가 있으면 회전시킨다.
	if random_rotation_degree > 0:
		Util.rotate_random(self, random_rotation_degree)
		
		
		
	match type:
		Type.broken_by_oneshot:
			HP = Table.broken_by_oneshot_obstacle_hp
		Type.kind_of_box:
			HP = Table.kind_of_box_obstacle_hp
		Type.kind_of_rock:
			HP = Table.kind_of_rock_obstacle_hp
		Type.kind_of_steel:
			HP = Table.kind_of_steel_obstacle_hp
		Type.kind_of_power_cube:
			HP = Table.kind_of_power_cube_hp
			
	max_HP = HP
	if hp_bar != null:
		hp_bar.init(HP)
	
# damage 를 준다.
func damage(power):
	# steel은 절대 부서지면 안
	if type != Type.kind_of_steel:
		HP = HP - power
		
	on_take_damage()
	if hp_bar != null:
		hp_bar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()
func die():
	$Body.die()
	make_item()
	# 3초뒤 삭제
	yield(get_tree().create_timer(3), "timeout")
	call_deferred("queue_free")

func make_item():
	var item_maker = get_node_or_null("ItemMaker")
	if item_maker != null:
		item_maker.make_item(max_HP)
		
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
		
