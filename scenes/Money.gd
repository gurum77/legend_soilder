extends Area2D


export var money_amount = 1000

func _on_Money_body_entered(body):
	if body is PlayerBody:
		StaticData.total_money += money_amount
		StaticData.current_stage_money += money_amount
		# 더이상 선택되지 않게
		$CollisionShape2D.queue_free()
		$AnimationPlayer.play("bounce")


func _on_AnimationPlayer_animation_finished(anim_name):
	self.call_deferred("queue_free")
