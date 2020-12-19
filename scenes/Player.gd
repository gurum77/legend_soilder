extends KinematicBody2D

var velocity = Vector2(0, 0)
const SPEED = 150
export (NodePath) var move_joystick

enum {idle, walking, Die, Fire}

func _physics_process(delta):
	# 이동 / 애니메이션 처리
	move_and_animation(delta)
	
# 이동 방향에 맞게 회전
func rotate_by_velocity(velocity):
	self.look_at(position + velocity)
	
# 이동 / 애니메이션 처리를 한다.
func move_and_animation(delta):
	# velocity를 받아 온다.
	input_velocity_player()
	
	# 이동 속도에 따른 animation sprite 설정
	play_animation_by_velocity(velocity)
	
	# 이동 방향에 따라 player 회전
	rotate_by_velocity(velocity)
	
	# 이동	
	velocity = move_and_slide(velocity)
	velocity.x = lerp(velocity.x, 0, 0.2)
	velocity.y = lerp(velocity.y, 0, 0.2)
	
# player 입력을 받는다
func input_velocity_player():
	if Input.is_action_pressed("ui_left"):
		velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		velocity.x = SPEED
	if Input.is_action_pressed("ui_up"):
		velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		velocity.y = SPEED
#	elif move_joystick_node and move_joystick_node.is_working:
#		velocity = move_joystick_node.output.normalized() * SPEED

# velocity에 따라 player의 animation을 한다.
func play_animation_by_velocity(velocity):
	# walk
	if velocity.length() > 0.5:
		$LegAnimatedSprite.play("walk")
	# idle
	else:
		$LegAnimatedSprite.play("idle")	
