extends Node2D

var HP = 5000

func _ready():
	$HPBar.init(HP)
	add_to_group("player")
	
# damage 를 준다.
func damage(power):
	HP = HP - power
	$HPBar.set_hp(HP)
	if HP <= 0:
		HP = 0
		die()

func die():
	# dia animation 실행
	$Body/AnimatedSprites/BodyAnimatedSprite.play("die")
	$Body/AnimatedSprites/LegAnimatedSprite.visible = false
	$Body/AnimatedSprites/FireAnimatedSprite.visible = false
	
	# 모든 총돌 해제
	$Body/CollisionShape2D.queue_free()	

