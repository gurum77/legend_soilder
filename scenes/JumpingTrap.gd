extends Area2D


export var dist = 30
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _on_JumpingTrap_body_entered(body):
	# 목적지 계산
	var target_position:Vector2 = global_position + get_global_transform().x * dist
	if body is PlayerBody:
		$Tween.interpolate_property(body.get_parent(), "global_position", body.get_parent().global_position, target_position, 1, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.start()
