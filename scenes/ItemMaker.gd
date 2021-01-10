extends Node2D

var factor = 0.01


func make_item(hp):
	var amount = hp * factor
	var count = amount / Define.default_money_amount
	if count < 0:
		count = 1
	for i in count:
		var ins = Preloader.money.instance()
		ins.global_position = global_position
		get_tree().root.call_deferred("add_child", ins);
