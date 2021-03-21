extends Node2D
class_name Bush

export (int) var random_rotation_degree = 0

var dead = false
func _ready():
	# 랜덤 회전
	if random_rotation_degree > 0:
		Util.rotate_random(self, random_rotation_degree)
		
	# 0 ~ 1초 사이 랜덤하게 animation을 시작한다.
	var start_time = randf()
	$Timer.start(start_time);
	
	
	
# bush는 damage를 받기만 하면 파괴된다.
func damage():
	die()
	
func die():
	$Body.die()
	z_index = 0
	dead = true


func _on_Timer_timeout():
	$Body/AnimatedSprite.play()
	$Timer.stop()
