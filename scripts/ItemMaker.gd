extends Node2D
export (bool) var make_money = true
export (bool) var make_gem	= true
export (bool) var make_power_posion = false
var money_factor = 0.01
var gem_factor = 0.01

func make_item(hp):
	# money (hp에 비례해서 만든다)
	if make_money:
		run_make_money(hp)
	# gem (hp에 비례한 확률로 만든다)
	if make_gem:
		run_make_gem(hp)
	# power_posion 1개를 만든다.
	if make_power_posion:
		run_make_power_posion()
	

func add_instance(ins):
	ins.global_position = global_position
	get_tree().root.call_deferred("add_child", ins);
	
# power posion을 만든다.
func run_make_power_posion():
	var ins = Preloader.power_posion.instance()
	add_instance(ins)
			
# gem을 만든다
# todo : hp에 비례한 기준으로 세워서적용해야함
# 기본 확률 0.01
func run_make_gem(_hp):
	var val:int = (1.0 / gem_factor) as int
	var res = randi() % val # 0 ~ val 까지의 값이 랜덤하게 나온다.
	# 0이 나오면 보석생성
	if res == 0:
		var ins = Preloader.gem.instance()
		add_instance(ins)
	

func run_make_money(hp):
	var amount = hp * money_factor
	var count = amount / Define.default_money_amount
	if count < 0:
		count = 1
	var money_pack_count:int = count / 10
	count -= (money_pack_count * 10)
	for i in count:
		var ins = Preloader.money.instance()
		add_instance(ins)
	for i in money_pack_count:
		var ins = Preloader.money_pack.instance()
		add_instance(ins)
