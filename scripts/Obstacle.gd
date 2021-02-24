extends Node2D

class_name Obstacle

# 종류 (걷기만 해도 깨짐, 박스처럼 잘 깨짐, 돌처럼 단단함, 쇠처럼 절대 깨지지 않음
enum Type{broken_by_step, kind_of_box, kind_of_rock, kind_of_steel }
export (Type) var type
var HP = 3000
onready var hp_bar = get_node_or_null("HPBar")

# Called when the node enters the scene tree for the first time.
func _ready():
	match type:
		Type.broken_by_step:
			HP = Table.broken_by_step_obstacle_hp
		Type.kind_of_box:
			HP = Table.kind_of_box_obstacle_hp
		Type.kind_of_rock:
			HP = Table.kind_of_rock_obstacle_hp
		Type.kind_of_steel:
			HP = Table.kind_of_steel_obstacle_hp
			
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
		
