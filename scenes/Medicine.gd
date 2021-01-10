extends Area2D

# hp를 회복 하는 비율(1 : 100%)
export var recovery_hp_factor = 0.5

func _on_Medicine_body_entered(body):
	if body is PlayerBody:
		var player = body.get_parent() as Player
		player.HP += player.max_HP / 2
		if player.HP > player.max_HP:
			player.HP = player.max_HP
		player.get_node("HPBar").set_hp(player.HP)
		
		# 더이상 선택되지 않게
		$CollisionShape2D.queue_free()
		$AnimationPlayer.play("bounce")


func _on_AnimationPlayer_animation_finished(anim_name):
	self.call_deferred("queue_free")


