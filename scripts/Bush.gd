extends Node2D
export (int) var random_rotation_degree = 0

func _ready():
	# 랜덤 회전
	if random_rotation_degree > 0:
		Util.rotate_random(self, random_rotation_degree)
		
	# 0 ~ 1초 사이 랜덤하게 animation을 시작한다.
	var start_time = randf()
	yield(get_tree().create_timer(start_time), "timeout")
	$Body/AnimatedSprite.play()
	
	

	
	
func _on_Body_body_entered(body):
	if body is PlayerBody:
		modulate.a = 0.3


func _on_Body_body_exited(body):
	if body is PlayerBody:
		modulate.a = 1.0
