extends StaticBody2D

class_name Obstacle

export var HP = 3000
enum {idle, explosion, die}
var state = idle


# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")
	$HPBar.init(HP)
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func die():
	# 폭파 애니메이션
	state = explosion
	$AnimatedSprite.play("explosion")
	
	# 충돌검사 해제
	$CollisionShape2D.queue_free()
	# 3초뒤 삭제
	yield(get_tree().create_timer(10), "timeout")
	call_deferred("queue_free")
	


func _on_AnimatedSprite_animation_finished():
	if state == explosion:
		state = die
		$AnimatedSprite.play("die")
		
