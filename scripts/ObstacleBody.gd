extends StaticBody2D

class_name ObstacleBody
export var next_bomb = false
export var next_bomb_power = 2000

enum {idle, explosion, die}
var state = idle

func _ready():
	# layer / mask
	collision_layer = 0b10000
	collision_mask = 0b110110
	
	# next bomb power(soldier의 체력의 1/2로 한다)
	next_bomb_power = 3000 / 2
	
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

func die():
	# 폭파 애니메이션
	state = explosion
	Util.play_animation($AnimatedSprite, "explosion")
	
	# 충돌검사 해제
	$CollisionShape2D.queue_free()
	
	# 파괴된 뒤 폭파
	if next_bomb:
		var ins = Preloader.bomb.instance()
		get_tree().root.call_deferred("add_child", ins)
		ins.global_position = global_position
		ins.power = Table.get_enemy_hp(next_bomb_power, StaticData.current_stage)
		ins.scale = Vector2(1.5, 1.5)
		ins.player = true
		
	# 3초뒤 삭제
	yield(get_tree().create_timer(10), "timeout")
	call_deferred("queue_free")
	
func _on_AnimatedSprite_animation_finished():
	if state == explosion:
		state = die
		$AnimatedSprite.play("die")		
