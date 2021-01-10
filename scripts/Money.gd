extends Area2D


var money_amount = Define.default_money_amount
var max_dist = 30

func _ready():
	randomize()
	var dist = rand_range(0, 1) * max_dist
	var dir = Vector2(rand_range(0, 1), rand_range(0, 1))
	$Tween.interpolate_property(self, "global_position", global_position, global_position + dir * dist, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	
func _on_Money_body_entered(body):
	if body is PlayerBody:
		StaticData.total_money += money_amount
		StaticData.current_stage_money += money_amount
		# 더이상 선택되지 않게
		$CollisionShape2D.queue_free()
		$AnimationPlayer.play("bounce")


func _on_AnimationPlayer_animation_finished(anim_name):
	self.call_deferred("queue_free")
