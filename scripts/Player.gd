extends Node2D
class_name Player
signal dead

var HP = Table.player_hp
var max_HP = Table.player_hp

# item
var power_posion_nums = 0	# power posion 갯수

export (bool) var second_player = false
export var walk_speed = 100
export var dash_speed = 400

onready var effect_animated_sprite = get_node("Body/AnimatedSprites/EffectAnimatedSprite")
onready var leg_animated_sprite = get_node("Body/AnimatedSprites/LegAnimatedSprite")
onready var hp_bar = get_node_or_null("HUD/HPBar")
onready var power_posion_hud = get_node_or_null("HUD/PowerPosionHUD")
onready var camera = get_node_or_null("Camera2D")

# hp바를 최대 hp를 기준으로 초기화 한다.
func set_max_to_hp_bar():
	hp_bar.max_value = max_HP
	hp_bar.set_hp(HP)
	
	
func _ready():
	# signal 연결
	var world = get_tree().root.get_node_or_null("World")
	if world != null:
		var err = connect("dead", world, "on_Player_dead")
		if err != OK:
			push_error("connect failed")
	# util에 camera 연결
	Util.player_camera = $Camera2D
		
	# level에 맞게 hp를 재계산
	HP = Table.get_player_hp_by_level()
	max_HP = HP
	
	$Body.SPEED = walk_speed
	$DashAudio.stream.loop = false
	effect_animated_sprite.play("none")
	hp_bar.init(max_HP)
	add_to_group("player")
	
	# item HUD 연결
	connect_item_hud()
	
func connect_item_hud():
	power_posion_hud.player = self
		
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
	
	hp_bar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func on_take_damage(power):
	var ins = Preloader.hud.instance()
	ins.message = str(-power as int)
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
	power_posion_nums = 0
	max_HP = Table.get_player_hp_by_level()
	HP = max_HP
	hp_bar.set_hp(HP)
	$Body.revival()
	$Shield.start()

# dash를 한다
func dash():
	$Body.SPEED = dash_speed
	$DashAudio.play()
	effect_animated_sprite.play("dash")
	leg_animated_sprite.speed_scale = dash_speed / walk_speed
	$DashTimer.start()


func _on_DashTimer_timeout():
	$Body.SPEED = walk_speed
	leg_animated_sprite.speed_scale = 1
	effect_animated_sprite.play("none")
