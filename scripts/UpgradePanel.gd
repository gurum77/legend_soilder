extends Panel

enum UpgradeItem{power, interval, fire_range}
export (UpgradeItem) var upgrade_item = UpgradeItem.power
export (Define.Weapon) var weapon = Define.Weapon.Pistol

onready var weapon_information:WeaponInformation = StaticData.get_weapon_information(weapon)
var need_more_money_to_upgrade = false	# upgrade하기 위해서 돈이 더 필요한지?

func _ready():
	update()
	
func change_weapon(w):
	weapon = w
	weapon_information = StaticData.get_weapon_information(weapon)
	update()
	
func update():
	var title_text
	var value_text
	var level
	var is_max_level = false
	match upgrade_item:
		UpgradeItem.power:
			title_text = "POWER"
			value_text = str(stepify(Table.get_weapon_power_by_level(weapon), 1))
			level = weapon_information.power_level
			is_max_level = weapon_information.is_max_power_level()
		UpgradeItem.interval:
			title_text = "INT."
			value_text = str(stepify(Table.get_weapon_interval_by_level(weapon), 0.01))
			level = weapon_information.interval_level
			is_max_level = weapon_information.is_max_interval_level()
		UpgradeItem.fire_range:
			title_text = "RANGE"
			level = weapon_information.range_level
			is_max_level = weapon_information.is_max_range_level()
			
	$Title.text = title_text
	$Value.text = value_text
	update_bar(level)
	if is_max_level:
		$Button.disabled = true
		$Button.text = "MAX"
	else:
		$Button.disabled = false
		var upgrade_cost = Table.get_upgrade_cost(level+1)
		$Button.text = str(upgrade_cost)
		# 돈이 부족하면 text를 붉은색으로
		if StaticData.total_money < upgrade_cost:
			need_more_money_to_upgrade = true
			$Button.set("custom_colors/font_color", Color(1, 0, 0, 1))
		else:
			need_more_money_to_upgrade = false
			$Button.set("custom_colors/font_color", Color(1, 1, 1, 1))
		

func update_bar(level):
	var bars = $HBoxContainer.get_children()
	for i in range(bars.size()):
		# 켠다
		if level > i:
			bars[i].modulate.r = 1
			bars[i].modulate.g = 1
			bars[i].modulate.b = 1
		else:
			bars[i].modulate.r = 0.2
			bars[i].modulate.g = 0.2
			bars[i].modulate.b = 0.2
		

# UP 버튼
# 돈이 부족하면 shop으로 이동할지 물어본다.
func _on_Button_pressed():
	if need_more_money_to_upgrade:
		var dlg = AcceptDialog.new()
		dlg.dialog_text = "You need more money.\nGo to shop?"
		dlg.add_cancel("Cancel")
		dlg.get_ok().connect("pressed", self, "on_GoToShopButton_pressed")
		add_child(dlg)
		dlg.popup_centered()
		return
		
	var wi:WeaponInformation = StaticData.get_weapon_information(weapon)
	if wi == null:
		return
	match upgrade_item:
		UpgradeItem.power:
			wi.upgrade_power_level()
		UpgradeItem.fire_range:			
			wi.upgrade_range_level()
		UpgradeItem.interval:
			wi.upgrade_interval_level()
	update()

func on_GoToShopButton_pressed():
	pass
