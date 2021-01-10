extends Node2D

var factor = 0.1

var max_dist = 30
func make_item(hp):
	var amount = hp * factor
	var count = amount / Define.default_money_amount
	if count < 0:
		count = 1
	for i in count:
		var dist = rand_range(0, 1) * max_dist
		var dir = Vector2(rand_range(0, 1), rand_range(0, 1))
		
		var ins = Preloader.money.instance()
		ins.global_position = global_position
		get_tree().root.call_deferred("add_child", ins)
		$Tween.interpolate_property(ins, "global_position", ins.global_position, ins.global_position + dir * dist, 0.5, Tween.TRANS_EXPO, Tween.EASE_IN)
	$Tween.start()
	
