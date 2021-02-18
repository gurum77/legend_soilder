extends Node2D

var money_factor = 0.01
var gem_factor = 0.01

func make_item(hp):
	# money (hp에 비례해서 만든다)
	make_money(hp)
	# gem (hp에 비례한 확률로 만든다)
	make_gem(hp)

func add_instance(ins):
	ins.global_position = global_position
	get_tree().root.call_deferred("add_child", ins);
	
# gem을 만든다
# todo : hp에 비례한 기준으로 세워서적용해야함
# 기본 확률 0.01
func make_gem(hp):
	var val:int = (1.0 / gem_factor) as int
	var res = randi() % val # 0 ~ val 까지의 값이 랜덤하게 나온다.
	# 0이 나오면 보석생성
	if res == 0:
		var ins = Preloader.gem.instance()
		add_instance(ins)
	

func make_money(hp):
	var amount = hp * money_factor
	var count = amount / Define.default_money_amount
	if count < 0:
		count = 1
	for i in count:
		var ins = Preloader.money.instance()
		add_instance(ins)
