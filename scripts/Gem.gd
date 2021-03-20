extends ItemBase


var gem_amount = Define.default_gem_amount
var max_dist = 30
var player

func _ready():
	randomize()
	var dist = rand_range(0, 1) * max_dist
	var dir = Vector2(rand_range(0, 1), rand_range(0, 1))
	$Tween.interpolate_property(self, "global_position", global_position, global_position + dir * dist, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	

func get_item():
	if player is Player:
		if $AudioStreamPlayer2D != null:
			$AudioStreamPlayer2D.stream.loop = false
			$AudioStreamPlayer2D.play()
		
		player.power_posion_nums += 1
		player.max_HP += Table.power_posion_hp_up_amount
		player.HP += Table.power_posion_hp_up_amount
		player.set_max_to_hp_bar()
		
	
	# 더이상 선택되지 않게
	if $CollisionShape2D != null:
		$CollisionShape2D.queue_free()
	if $AnimationPlayer != null:
		$AnimationPlayer.play("bounce")
	
func _on_Money_body_entered(body):
	if body is PlayerBody:
		player = body.get_parent()
		get_item()

func _on_AnimationPlayer_animation_finished(_anim_name):
	self.call_deferred("queue_free")
