extends ItemBase

enum MoneyType{money, money_pack}
export (MoneyType) var money_type = MoneyType.money
var money_amount = Define.default_money_amount
var max_dist = 30

onready var stream_player = get_node_or_null("AudioStreamPlayer2D")

func _ready():
	if money_type == MoneyType.money:
		money_amount = Define.default_money_amount
	elif money_type == MoneyType.money_pack:
		money_amount = Define.default_money_amount * 10
	randomize()
	var dist = rand_range(0, 1) * max_dist
	var dir = Vector2(rand_range(0, 1), rand_range(0, 1))
	$Tween.interpolate_property(self, "global_position", global_position, global_position + dir * dist, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	

func get_item():
	if stream_player != null:
		stream_player.play()
	StaticData.total_money += money_amount
	StaticData.current_stage_money += money_amount
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
