extends Area2D

var speed = 500

export (Define.Weapon) var weapon

# 화면을 벗어나면 삭제
func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _ready():
	# 무기종류에 맞는 animation을 실행
	var animation_name = Define.get_weapon_name(weapon)
	$BulletAnimatedSprite.play(animation_name)
	
	# 무기 종류에 맞는 소리 실행
	$AudioStreamPlayer2D.stream = SoundManager.get_bullet_shot_audio_stream(weapon)
	$AudioStreamPlayer2D.play()
	
	
# bullet이 날아가도록 한다
func _physics_process(delta):
	translate(Vector2.RIGHT.rotated(rotation) * speed * delta)
