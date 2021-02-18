extends ItemBase


var gem_amount = Define.default_gem_amount
var max_dist = 30

func _ready():
	randomize()
	var dist = rand_range(0, 1) * max_dist
	var dir = Vector2(rand_range(0, 1), rand_range(0, 1))
	$Tween.interpolate_property(self, "global_position", global_position, global_position + dir * dist, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	

func get_item():
	StaticData.total_gem += gem_amount
	StaticData.current_stage_gem += gem_amount
	# 더이상 선택되지 않게
	if $CollisionShape2D != null:
		$CollisionShape2D.queue_free()
	if $AnimationPlayer != null:
		$AnimationPlayer.play("bounce")
	
func _on_Money_body_entered(body):
	if body is PlayerBody:
		get_item()

func _on_AnimationPlayer_animation_finished(_anim_name):
	self.call_deferred("queue_free")
