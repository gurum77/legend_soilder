extends StaticBody2D

class_name ObstacleBody

enum {idle, explosion, die}
var state = idle

func _ready():
	$AnimatedSprite.connect("animation_finished", self, "_on_AnimatedSprite_animation_finished")

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
